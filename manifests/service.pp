# PRIVATE CLASS: do no include directly
class nscd::service {
  if $::nscd::service_manage {
    service { $::nscd::service_name :
      ensure    => $::nscd::service_ensure,
      enable    => $::nscd::service_enable,
      subscribe => Class['::nscd::config'],
    }

    if $::nscd::service_user_manage {
      group { $::nscd::service_user :
        ensure => present,
        gid    => $::nscd::service_user_uid,
      } ->

      user { $::nscd::service_user :
        ensure  => present,
        uid     => $::nscd::service_user_uid,
        comment => 'NSCD Daemon',
        home    => '/',
        system  => true,
        shell   => $::nscd::service_user_shell,
        before  => Service[$::nscd::service_name],
      }
    }
  }
}
