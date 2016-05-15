# PRIVATE CLASS: do not include directly
class nscd::config inherits nscd {
  if $::nscd::config_manage {
    concat { $::nscd::config_file :
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      seluser => 'system_u',
      selrole => 'object_r',
      seltype => 'etc_t',
    }

    concat::fragment { 'config_header_fragment' :
      target  => $::nscd::config_file,
      content => template("${module_name}/config_header.erb"),
      order   => '00',
    }
  }
}
