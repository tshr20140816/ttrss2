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
$count = 0;
foreach ($pdo->query($sql) as $row) {
    error_log(print_r($row, true));
    $count = $row['cnt'];
}

$pdo = null;

header('Content-Type: application/xml');

$xml_text = <<< __HEREDOC__
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>quota</title>
    <link>https://www.heroku.com/</link>
    <description>none</description>
    <language>ja</language>
    <item><title>__TITLE__</title><link>https://www.heroku.com/</link><description>__DESCRIPTION__</description><pubDate/></item>
  </channel>
</rss>
__HEREDOC__;

$xml_text = str_replace('__TITLE__', $count, $xml_text);
$xml_text = str_replace('__DESCRIPTION__', date(' Y/m/d H:i', strtotime('+9 hours')), $xml_text);
echo $xml_text;
