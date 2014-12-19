define puppetmaster::authrule (
  $comment = undef,
  $path,
  $auth = undef,
  $method = undef,
  $allow = undef,
  $order,
) {
  include puppetmaster::auth

  concat::fragment { "puppetmaster-auth.conf/${name}":
    target => '/etc/puppet/auth.conf',
    content => template('puppetmaster/auth.rule.erb'),
    order => $order,
  }
}
