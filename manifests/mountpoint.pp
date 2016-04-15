define puppetmaster::mountpoint(
	$path,
	$allow = ['*'],
	$deny = [],
) {
  include puppetmaster::params

	if versioncmp($::puppetversion, '4.0') < 0 {
		$allow_rules = inline_template('<% @allow.each do |value| -%>
			set \'allow[. = "<%= value %>"]\' \'<%= value %>\'
		<%- end %>')
		$deny_rules = inline_template('<% @deny.each do |value| -%>
			set \'deny[. = "<%= value %>"]\' \'<%= value %>\'
		<%- end %>')

		$fileserver_changes = "set path ${path}\n${allow_rules}\n${deny_rules}"
	} else {
		$fileserver_changes = 'set \'allow[. = "*"]\' \'*\''

		puppetmaster::authrule { "mountpoint $name":
			path => "~ ^/puppet/v3/file_(metadata|content)/${name}/",
			auth => 'yes',
			allow => $allow,
			order => 450,
		}
	}

	augeas { "puppetmaster::mountpoint::${name}":
		context => "/files/${puppetmaster::params::config_root}/fileserver.conf/${name}/",
		changes => $fileserver_changes,
		notify => Service[$puppetmaster::puppetmaster_service_name],
	}
}
