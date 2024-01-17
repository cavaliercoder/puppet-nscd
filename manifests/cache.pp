# See README.md for usage information
#
# @param enable
# @param positive_ttl
# @param negative_ttl
# @param suggested_size
# @param check_files
# @param persistent
# @param shared
# @param max_db_size
# @param auto_propagate
#
define nscd::cache (
  Boolean $enable                   = $nscd::params::cache_enable,
  Optional[Integer] $positive_ttl   = $nscd::params::cache_positive_ttl,
  Optional[Integer] $negative_ttl   = $nscd::params::cache_negative_ttl,
  Integer $suggested_size           = $nscd::params::cache_suggested_size,
  Boolean $check_files              = $nscd::params::cache_check_files,
  Boolean $persistent               = $nscd::params::cache_persistent,
  Boolean $shared                   = $nscd::params::cache_shared,
  Integer $max_db_size              = $nscd::params::cache_max_db_size,
  Optional[Boolean] $auto_propagate = $nscd::params::cache_auto_propagate,
) {
  # include nscd if not already defined
  include nscd

  # check that config file is being managed
  if ! $nscd::config_manage {
    fail('nscd::cache was defined but nscd::config_manage is false')
  }

  concat::fragment { "config_${name}_fragment" :
    target  => $nscd::config_file,
    content => template("${module_name}/config_cache.erb"),
    order   => '10',
    notify  => Class['nscd::service'],
  }
}
