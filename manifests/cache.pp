# See README.md for usage information
define nscd::cache (
  $enable         = $::nscd::params::cache_enable,
  $positive_ttl   = $::nscd::params::cache_positive_ttl,
  $negative_ttl   = $::nscd::params::cache_negative_ttl,
  $suggested_size = $::nscd::params::cache_suggested_size,
  $check_files    = $::nscd::params::cache_check_files,
  $persistent     = $::nscd::params::cache_persistent,
  $shared         = $::nscd::params::cache_shared,
  $max_db_size    = $::nscd::params::cache_max_db_size,
  $auto_propagate = $::nscd::params::cache_auto_propagate,
) {
  # include nscd if not already defined
  include nscd

  # check that config file is being managed
  if ! $::nscd::config_manage {
    fail('nscd::cache was defined but nscd::config_manage is false')
  }

  validate_re($name, '^(passwd|group|hosts|services|netgroup)$')
  validate_bool($enable, $check_files, $persistent, $shared)
  validate_integer($positive_ttl)
  validate_integer($negative_ttl)
  validate_integer($suggested_size)
  validate_integer($max_db_size)

  if $auto_propagate {
    validate_re($name, '^(passwd|group)$')
    validate_bool($auto_propagate)
  }

  concat::fragment { "config_${name}_fragment" :
    target  => $::nscd::config_file,
    content => template("${module_name}/config_cache.erb"),
    order   => '10',
    notify  => Class['::nscd::service'],
  }
}
