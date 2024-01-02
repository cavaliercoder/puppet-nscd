# See README.md for usage information
#
# @param package_manage
# @param package_name
# @param package_ensure
# @param service_manage
# @param service_defaults
# @param service_name
# @param service_ensure
# @param service_enable
# @param service_user_manage
# @param service_user
# @param service_user_uid
# @param service_user_gid
# @param config_manage
# @param config_file
# @param log_file
# @param debug_level
# @param threads
# @param max_threads
# @param stat_user
# @param reload_count
# @param paranoia
# @param restart_interval
#
class nscd (
  Boolean $package_manage                = $nscd::params::package_manage,
  String $package_name                   = $nscd::params::package_name,
  String $package_ensure                 = $nscd::params::package_ensure,
  Boolean $service_manage                = $nscd::params::service_manage,
  Boolean $service_defaults              = $nscd::params::service_defaults,
  String $service_name                   = $nscd::params::service_name,
  String $service_ensure                 = $nscd::params::service_ensure,
  Boolean $service_enable                = $nscd::params::service_enable,
  Boolean $service_user_manage           = $nscd::params::service_user_manage,
  String $service_user                   = $nscd::params::service_user,
  Integer $service_user_uid              = $nscd::params::service_user_uid,
  Integer $service_user_gid              = $nscd::params::service_user_gid,
  Boolean $config_manage                 = $nscd::params::config_manage,
  String $config_file                    = $nscd::params::config_file,
  String $log_file                       = $nscd::params::log_file,
  Integer $debug_level                   = $nscd::params::debug_level,
  Integer $threads                       = $nscd::params::threads,
  Integer $max_threads                   = $nscd::params::max_threads,
  Optional[String] $stat_user            = $nscd::params::stat_user,
  Variant[Integer, String] $reload_count = $nscd::params::reload_count,
  Boolean $paranoia                      = $nscd::params::paranoia,
  Integer $restart_interval              = $nscd::params::restart_interval,
) inherits nscd::params {
  contain 'nscd::install'
  contain 'nscd::config'
  contain 'nscd::service'

  Class['nscd::install']
  -> Class['nscd::config']
  ~> Class['nscd::service']

  if $service_defaults {
    class { 'nscd::service_defaults' : }
  }
}
