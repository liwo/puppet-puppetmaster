define puppetmaster::mountpoint(
	$path,
	$allow = ['*'],
	$deny = [],
) {

	$allow_rules = inline_template('<% @allow.each do |value| -%>
		set \'allow[. = "<%= value %>"]\' \'<%= value %>\'
	<%- end %>')
	$deny_rules = inline_template('<% @deny.each do |value| -%>
		set \'deny[. = "<%= value %>"]\' \'<%= value %>\'
	<%- end %>')

	$changes = "set path ${path}\n${allow_rules}\n${deny_rules}"

	augeas { "puppetmaster::mountpoint::${name}":
		context => "/files/etc/puppet/fileserver.conf/${name}/",
		changes => $changes,
		notify => Service[$puppetmaster::puppetmaster_service_name],
	}
}
