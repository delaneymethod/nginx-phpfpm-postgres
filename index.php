<?php
$dbconn = pg_connect("host=localhost dbname=postgres user=postgres password=postgres") or die(pg_last_error());

pg_close($dbconn);

echo 'This is a Production ready Docker Image';

phpinfo();
