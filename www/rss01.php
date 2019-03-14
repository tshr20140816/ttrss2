<?php

$connection_info = parse_url(getenv('DATABASE_URL'));

$sql = <<< __HEREDOC__
SELECT SUM(T1.reltuples) cnt
  FROM pg_class T1
 WHERE EXISTS ( SELECT 'X'
                  FROM pg_stat_user_tables T2
                 WHERE T2.relname = T1.relname
                   AND T2.schemaname='public'
              )
__HEREDOC__;

$pdo = new PDO(
    "pgsql:host=${connection_info['host']};dbname=" . substr($connection_info['path'], 1),
    $connection_info['user'],
    $connection_info['pass']
);
$count_record = 0;
foreach ($pdo->query($sql) as $row) {
    error_log(print_r($row, true));
    $count_record = $row['cnt'];
}

$pdo = null;

$api_key = getenv('HEROKU_API_KEY');
$url = 'https://api.heroku.com/account';

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Accept: application/vnd.heroku+json; version=3',"Authorization: Bearer ${api_key}"]);
$res = curl_exec($ch);
curl_close($ch);

$data = json_decode($res, true);
error_log('$data : ' . print_r($data, true));

$url = "https://api.heroku.com/accounts/${data['id']}/actions/get-quota";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Accept: application/vnd.heroku+json; version=3.account-quotas',"Authorization: Bearer ${api_key}"]);
$res = curl_exec($ch);
curl_close($ch);

$data = json_decode($res, true);
error_log('$data : ' . print_r($data, true));

$dyno_used = (int)$data['quota_used'];
$dyno_quota = (int)$data['account_quota'];

$quota = $dyno_quota - $dyno_used;
$quota = floor($quota / 86400) . 'd ' . ($quota / 3600 % 24) . 'h ' . ($quota / 60 % 60) . 'm';

$last_day = (int)date('d', strtotime('last day of ' . date('Y-m'))) - (int)date('d') + 1;

error_log(floor($quota / 86400));
error_log($last_day);

if (floor($quota / 86400) > $last_day) {
    $quota .= ' OK';
} else {
    $quota .= ' NG';
}

error_log($quota);

header('Content-Type: application/xml');

$xml_text = <<< __HEREDOC__
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>record count</title>
    <link>__LINK__</link>
    <description>none</description>
    <language>ja</language>
    <item><title>__TITLE__</title><link>__LINK__</link><description>__DESCRIPTION__</description><pubDate/></item>
  </channel>
</rss>
__HEREDOC__;

$xml_text = str_replace('__TITLE__', $quota . ' ' . $count_record, $xml_text);
$xml_text = str_replace('__DESCRIPTION__', date('Y/m/d H:i', strtotime('+9 hours')), $xml_text);
$xml_text = str_replace('__LINK__', 'https://' . getenv('HEROKU_APP_NAME') . '.herokuapp.com/ttrss/', $xml_text);
echo $xml_text;

error_log("opcache_get_status : " . print_r(opcache_get_status(), true));
