<?php
$CONFIG = array (
  'appstoreenabled' => false,
  'datadirectory' => '/owncloud-data',
  'activity_expire_days' => 15,
  'filelocking.enabled' => 'true',
  'memcache.local' => '\OC\Memcache\Redis',
  'memcache.locking' => '\OC\Memcache\Redis',
  'redis' => array (
    'host' => '/var/run/redis/redis.sock',
    'port' => 0,
    'timeout' => 0.0,
  ),
);
