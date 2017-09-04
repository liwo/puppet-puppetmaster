class puppetmaster::auth {
  include puppetmaster::params

  $auth_conf = "${puppetmaster::params::config_root}/auth.conf"

  concat { $auth_conf:
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  if versioncmp($::puppetversion, '4.0') < 0 {
    include puppetmaster::auth::puppet3
  } else {
    include puppetmaster::auth::puppet4
  }
}
