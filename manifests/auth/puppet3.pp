class puppetmaster::auth::puppet3 {
  concat::fragment { 'puppetmaster-auth.conf/header':
    target => $puppetmaster::auth::auth_conf,
    source => 'puppet:///modules/puppetmaster/auth.conf.header.puppet3',
    order => 0,
  }

  puppetmaster::authrule { 'own-catalog':
    comment => '
      ### Authenticated ACLs - these rules apply only when the client
      ### has a valid certificate and is thus authenticated

      # allow nodes to retrieve their own catalog',
    path => '~ ^/catalog/([^/]+)$',
    method => 'find',
    allow => '$1',
    order => 100,
  }
  puppetmaster::authrule { 'own-definition':
    comment => '# allow nodes to retrieve their own node definition',
    path => '~ ^/node/([^/]+)$',
    method => 'find',
    allow => '$1',
    order => 200,
  }
  puppetmaster::authrule { 'certificate-service':
    comment => '# allow all nodes to access the certificates services',
    path => '/certificate_revocation_list/ca',
    method => 'find',
    allow => '*',
    order => 300,
  }
  puppetmaster::authrule { 'own-reports':
    comment => '# allow all nodes to store their own reports',
    path => '~ ^/report/([^/]+)$',
    method => 'save',
    allow => '$1',
    order => 400,
  }
  puppetmaster::authrule { 'files':
    comment => '# Allow all nodes to access all file services; this is necessary for
      # pluginsync, file serving from modules, and file serving from custom
      # mount points (see fileserver.conf). Note that the `/file` prefix matches
      # requests to both the file_metadata and file_content paths. See "Examples"
      # above if you need more granular access control for custom mount points.',
    path => '/file',
    allow => '*',
    order => 500,
  }
  puppetmaster::authrule { 'ca':
    comment => '### Unauthenticated ACLs, for clients without valid certificates; authenticated
      ### clients can also access these paths, though they rarely need to.

      # allow access to the CA certificate; unauthenticated nodes need this
      # in order to validate the puppet master\'s certificate',
    path => '/certificate/ca',
    auth => 'any',
    method => 'find',
    allow => '*',
    order => 600,
  }
  puppetmaster::authrule { 'own-certificate':
    comment => '# allow nodes to retrieve the certificate they requested earlier',
    path => '/certificate/',
    auth => 'any',
    method => 'find',
    allow => '*',
    order => 700,
  }
  puppetmaster::authrule { 'csr':
    comment => '# allow nodes to request a new certificate',
    path => '/certificate_request',
    auth => 'any',
    method => 'find, save',
    allow => '*',
    order => 800,
  }
  puppetmaster::authrule { 'deny-all':
    comment => '# deny everything else; this ACL is not strictly necessary, but
      # illustrates the default policy.',
    path => '/',
    auth => 'any',
    order => 900,
  }
}
