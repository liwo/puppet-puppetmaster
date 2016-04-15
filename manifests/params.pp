# Class: puppetmaster::params
#
# This class configures parameters for the puppet-puppetmaster module.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetmaster::params {

  case $::operatingsystem {
    'centos', 'redhat', 'fedora': {
      $puppetmaster_package_name  = 'puppet-server'
      $puppetmaster_service_name  = 'puppetmaster'
      $puppetmaster_passenger_package = 'puppetmaster-passenger'
      package { 'puppetlabs-release-6-6.noarch.rpm':
        ensure   => present,
        source   => 'http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-6.noarch.rpm',
        provider => rpm,
      }
    }
    'ubuntu', 'debian': {
      $puppetmaster_package_name  = 'puppetmaster'
      $puppetmaster_service_name  = 'puppetmaster'
      $puppetmaster_passenger_package = 'puppetmaster-passenger'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }

  if versioncmp($::puppetversion, '4.0') < 0 {
    $config_root = '/etc/puppet'
  } else {
    $config_root = '/etc/puppetlabs/puppet'
  }
}
