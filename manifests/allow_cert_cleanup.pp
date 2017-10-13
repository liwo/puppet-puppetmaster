class puppetmaster::allow_cert_cleanup (
	$allowed_nodes = '*',
) {
	if versioncmp($::clientversion, '4.0.0') < 0 {
		puppetmaster::authrule { 'cert-cleanup':
			comment => '# Allows nodes to clean up certificates of any node. This is being triggered
      # at provisioning time in kickstart to remove the old certificate, since a new
      # one is generated when the system is provisioned.',
			path => '/certificate_status/',
			auth => 'any',
			method => 'find, save, destroy',
			allow => $allowed_nodes,
			order => 810,
		}
	} else {
		hocon_setting { 'cert-cleanup':
			path => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
			setting => 'authorization.rules',
			type => 'array_element',
			value => {
				'match-request' => {
					'path' => '/puppet-ca/v1/certificate_status',
					'type' => 'path',
					'method' => 'delete',
				},
				'allow-unauthenticated' => true,
				'sort-order' => 500,
				'name' => 'allow-cert-cleanup',
			},
			notify => Service['puppetserver'],
		}
	}

}
