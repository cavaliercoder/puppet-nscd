# PRIVATE CLASS: do not include directly
class nscd::install {
  if $::nscd::package_manage {
    package { 'nscd' :
      name   => $::nscd::package_name,
      ensure => $::nscd::package_ensure,
    }
  }	
}
