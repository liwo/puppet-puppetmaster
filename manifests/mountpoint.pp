define puppetmaster::mountpoint(
	$path,
	$allow = ['*'],
	$deny = [],
) {

	$allow_rules = prefix($allow, 'set allow[*] ')
	$deny_rules = prefix($deny, 'set deny[*] ')

	$changes = concat(concat(["set path ${path}"], $allow_rules), $deny_rules)

	augeas { "puppetmaster::mountpoint::${name}":
		context => "/files/etc/puppet/fileserver.conf/${name}/",
		changes => $changes,
		notify => Service[$puppetmaster::puppetmaster_service_name],
	}
}
