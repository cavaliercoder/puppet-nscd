# nscd

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with nscd](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The nscd module installs, configures and manages the name service cache daemon
on unix-like operating systems.

## Setup

### What nscd affects

* The `nscd` package will be installed unless `package_manage` is set to `false`
* The `nscd.conf` configuration file will be overwritten unless `config_manage`
  is set to `false`

### Beginning with nscd

Declare the main `::nscd` class and apply default cache configurations:

```puppet
class { '::nscd' : service_defaults => true }

```

## Usage

Daemon configuration is managed through the main `::nscd` class while individual
service caches (such as `passwd` or `group`) are managed using declarations of
the `::nscd::cache` resource type.

### Install and start nscd with binary defaults

```puppet
class { '::nscd' : }

```

This will install the nscd package, configure daemon defaults and start the
`nscd` service. No caches will be configured or enabled.

### Install and start nscd with distribution defaults

```puppet
class { '::nscd' : service_defaults => true }

```

This will install the nscd package, configure daemon defaults, enable and
configure service caches as per the defaults for your operating system and
finally start the nscd service.

## Reference

### Public classes

#### Class: `nscd`

Guides the basic setup and installation of the name service cache daemon on your
system.

When this class is declared with the default options, Puppet:

* Installs the `nscd` software package for your operating system
* Replaces and manages the `nscd.conf` configuration file
  * Distribution defaults are used for the daemon itself
  * Binary defaults are used for all supported caches unless `service_defaults`
    is set to `true` in which case distribution defaults are configured
* Enables and starts the `nscd` service

You can validate the state of nscd and its caches by calling

  $ nscd --statistics

**Parameters within `nscd`:**

##### `config_file`

Set the path fo the nscd configuration file to be managed. 
Default: `/etc/nscd.conf`

##### `config_manage`

Determines whether to manage the nscd daemon configuration file. If `false`,
the configuration file must be managed manually and `::nscd::cache` definitions
will fail. Valid options: Boolean. Default: true.

##### `debug_level`

Sets the desired debug level for the log file. Default: 0.

##### `log_file`

Set the path of the daemon log file. Default: `/var/log/nscd.log`.

##### `max_threads`

Sets the maximum number of threads. Default: 32.

##### `package_ensure`

Controls the `package` resource's [`ensure`][] attribute. Valid options:
'absent', 'installed' (or the equivalent 'present'), or a version string. 
Default: 'installed'.

##### `package_manage`

Determines whether the `nscd` package will be installed and managed. Set to
`false` if you wish to manually manage the installation. Default: `true`.

##### `package_name`

Sets the names of the package to be installed. Default: `nscd`.

##### `paranoia`

Determines whether to enable paranoia mode which causes nscd to restart itself
periodically. Valid options: Boolean. Default: true.

##### `reload_count`

Sets the limit on the number of times a cached entry gets reloaded without being
used before it gets removed. Default: 5.

##### `restart_interval`

Sets the restart interval to time seconds if periodic restart is enabled by
enabling paranoia mode. Default: 3600 (1 hour).

##### `service_defaults`

Determines whether default cache service configurations should be applied by
including the `::nscd::service_defaults` class and its `::nscd::cache`
declarations. Valid options: Boolean. Default: true.

##### `service_enable`

Determines whether Puppet enables the nscd service when the system is booted.
Valid options: Boolean. Default: true.

##### `service_ensure`

Determines whether Puppet should make sure the service is running. Valid
options: 'true' (equivalent to 'running'), 'false' (equivalent to 'stopped').
Default: 'running'.

##### `service_manage`

Determines whether Puppet manages the nscd service's state. Valid options:
Boolean. Default: true.

##### `service_name`

Sets the name of the nscd service. Default: `nscd`.

##### `service_user`

Sets the name of the service account under which the nscd service will run.
Default: `nscd`.

##### `service_user_gid`

Sets the group ID of the nscd service account. Default: 28.

##### `service_user_manage`

Determines whether Puppet manages the nscd service account. Valid options:
Boolean. Default: true.

##### `service_user_uid`

Sets the user ID of the nscd service account. Default: 28.

##### `stat_user`

Specifies the user who is allowed to request statistics.

##### `threads`

Set the number of threads that are started to wait for requests. At least five
threads will always be created. Default: 4.

### Private classes

#### Class: `nscd::config`

Manages the nscd configuration file.

#### Class: `nscd::install`

Installs the nscd package.

#### Class: `nscd::params`

Manages nscd parameters for different operating systems.

#### Class: `nscd::service`

Manages the nscd daemon and runtime user account.

#### Class: `nscd::service_defaults`

### Public defined types

#### Defined class: `nscd::cache`

Defines the configuration for a supported service cache.

**Parameters within `nscd::cache`:**

#### `name`

Sets the name of the service to be configured.

#### `auto_propagate`

When set to `false` for `passwd` or `group` service, then the `.byname` requests
are not added to `passwd.byuid` or `group.bygid` cache. This can help with
tables containing multiple records for the same ID. This parameter is valid only
for services `passwd` and `group`. Default: `undef`.

##### `check_files`

Enables or disables checking the file belonging to the specified service for
changes. Valid options: Boolean. Default: true.

##### `enable`

Enables or disables the specified service cache. Valid options: Boolean.
Default: true.

##### `max_db_size`

The maximum allowable size, in bytes, of the database files for the service.
Default: 33554432 (32MB).

##### `negative_ttl`

Sets the TTL (time-to-live) for negative entries (unsuccessful queries) in the
specified cache for service. Value is in seconds. Can result in significant
performance improvements if there are several files owned by UIDs (user IDs) not
in system databases (for example untarring the Linux kernel sources as root);
should be kept small to reduce cache coherency problems. Required. 
Default: `undef`.

##### `persistent`

Keep the content of the cache for service over server restarts; useful when
paranoia mode is set. Valid options: Boolean. Default: false.

##### `positive_ttl`

Sets the TTL (time-to-live) for positive entries (successful queries) in the
specified cache for service. Value is in seconds. Larger values increase cache
hit rates and reduce mean response times, but increase problems with cache
coherence. Required. Default: `undef`.

##### `shared`

The memory mapping of the nscd databases for service is shared with the clients
so that they can directly search in them instead of having to ask the daemon
over the socket each time a lookup is performed. Valid options: Boolean.
Default: false.

##### `suggested_size`

Sets the the internal hash table size. Value should remain a prime number for
optimum efficiency. Default: 211.

## Limitations

### Debian/Ubuntu

As per [Ubuntu bug 1068889](https://bugs.launchpad.net/ubuntu/+source/eglibc/+bug/1068889),
the `netgroup` service cache is known not to work on Debian based systems and is
therefore disable by default by this module.

## Development

Contributions are welcome in the form of issues and pull requests on
[GitHub](https://github.com/cavaliercoder/puppet-nscd).
