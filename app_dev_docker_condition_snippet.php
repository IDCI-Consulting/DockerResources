<?php

// The following snippet allows app_dev.php for dockerized applications.
// You need to replace your actual condition in /your/project/web/app_dev.php

$dockerized = (bool) strstr($_SERVER['REMOTE_ADDR'], '172.');

if (isset($_SERVER['HTTP_CLIENT_IP'])
    || isset($_SERVER['HTTP_X_FORWARDED_FOR']) && !$dockerized
    || !in_array(@$_SERVER['REMOTE_ADDR'], array('127.0.0.1', 'fe80::1', '::1')) && !$dockerized
) {
    header('HTTP/1.0 403 Forbidden');
    exit('You are not allowed to access this file. Check '.basename(__FILE__).' for more information.');
}
