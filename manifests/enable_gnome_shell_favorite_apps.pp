# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dconf::enable_gnome_shell_favorite_apps
class dconf::enable_gnome_shell_favorite_apps {
  datacat { 'enabled-gnome-shell-favorite_apps':
    path     => '/etc/dconf/db/site.d/enabled-gnome-shell-favorite-apps',
    template => 'dconf/enabled-gnome-shell-favorite-apps.ini.erb',
    notify   => Class['dconf::update'],
  }
}
