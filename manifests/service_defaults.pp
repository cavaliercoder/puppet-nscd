# PRIVATE CLASS: do not include directly
class nscd::service_defaults {
  nscd::cache { 'passwd' : 
    positive_ttl   => 600,
    negative_ttl   => 20,
    persistent     => true,
    shared         => true,
    auto_propagate => true,
  }

  nscd::cache { 'group' : 
    positive_ttl   => 3600,
    negative_ttl   => 60,
    persistent     => true,
    shared         => true,
    auto_propagate => true,
  }
  
  nscd::cache { 'hosts' :
    positive_ttl   => 3600,
    negative_ttl   => 20,
    persistent     => true,
    shared         => true,
 }

  nscd::cache { 'services' : 
    positive_ttl   => 28800,
    negative_ttl   => 20,
    persistent     => true,
    shared         => true,
  }

  # netgroup caching is known-broken, so disable it in the default config,
  # see: https://bugs.launchpad.net/ubuntu/+source/eglibc/+bug/1068889
  nscd::cache { 'netgroup' : 
    enable         => $::osfamily != 'Debian',
    positive_ttl   => 28800,
    negative_ttl   => 20,
    persistent     => true,
    shared         => true,
  }
}
