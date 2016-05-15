# PRIVATE CLASS: do not include directly
class nscd::install {
  if $::nscd::package_manage {
    package { 'nscd' :
      ensure => $::nscd::package_ensure,
      name   => $::nscd::package_name,
    }
  }
}
