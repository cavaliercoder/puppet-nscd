class nscd::params {
  $package_manage      = true
  $package_name        = 'nscd'
  $package_ensure      = 'installed'

  $service_manage      = true
  $service_defaults    = false
  $service_name        = 'nscd'
  $service_ensure      = 'running'
  $service_enable      = true

  $service_user_manage = true
  $service_user        = 'nscd'
  $service_user_uid    = 28
  $service_user_gid    = 28

  $config_manage       = true
  $config_file         = '/etc/nscd.conf'

  $log_file            = '/var/log/nscd.log'
  $debug_level         = 0
  $threads             = 4
  $max_threads         = 32
  $stat_user           = undef
  $reload_count        = 5
  $paranoia            = false
  $restart_interval    = 3600

  case $facts['os']['family'] {
    'Debian': {
      $service_user_shell = '/usr/sbin/nologin'
    }

    default: {
      $service_user_shell = '/sbin/nologin'
    }
  }

  $cache_enable = true
  $cache_positive_ttl = undef
  $cache_negative_ttl = undef
  $cache_suggested_size = 211
  $cache_check_files = true
  $cache_persistent = false
  $cache_shared = false
  $cache_max_db_size = 33554432
  $cache_auto_propagate = undef
}
