# See README.md for usage information
class nscd (
  $package_manage   = $::nscd::params::package_manage,
  $package_name     = $::nscd::params::package_name,
  $package_ensure   = $::nscd::params::package_ensure,

  $service_manage   = $::nscd::params::service_manage,
  $service_defaults = $::nscd::params::service_defaults,
  $service_name     = $::nscd::params::service_name,
  $service_ensure   = $::nscd::params::service_ensure,
  $service_enable   = $::nscd::params::service_enable,
  $service_user_manage = $::nscd::params::service_user_manage,
  $service_user     = $::nscd::params::service_user,
  $service_user_uid = $::nscd::params::service_user_uid,
  $service_user_gid = $::nscd::params::service_user_gid,

  $config_manage    = $::nscd::params::config_manage,
  $config_file      = $::nscd::params::config_file,

  $log_file         = $::nscd::params::log_file,
  $debug_level      = $::nscd::params::debug_level,
  $threads          = $::nscd::params::threads,
  $max_threads      = $::nscd::params::max_threads,
  $stat_user        = $::nscd::params::stat_user,
  $reload_count     = $::nscd::params::reload_count,
  $paranoia         = $::nscd::params::paranoia,
  $restart_interval = $::nscd::params::restart_interval,
) inherits nscd::params {
  validate_absolute_path($config_file)
  validate_absolute_path($log_file)
  validate_integer($debug_level, '', 0)
  validate_integer($threads, '', 1)
  validate_integer($max_threads, '', $threads)
  if is_string($reload_count) {
    validate_re($reload_count, '^unlimited$')
  } else {
    validate_integer($reload_count)
  }
  validate_bool($paranoia)
  validate_integer($restart_interval, '', 0)

  anchor { '::nscd::begin' : } ->
  class { '::nscd::install' : } ->
  class { '::nscd::config' : } ->
  class { '::nscd::service' : } ->
  anchor { '::nscd::end' : }

  if $service_defaults {
    class { '::nscd::service_defaults' : }
  }
}
