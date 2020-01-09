class dconf::update {
  exec { '/usr/bin/dconf update':
    refreshonly => true,
  }
}
