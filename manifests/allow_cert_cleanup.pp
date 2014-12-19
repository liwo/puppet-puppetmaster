class puppetmaster::allow_cert_cleanup (
  $allowed_nodes = '*',
) {
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
}
