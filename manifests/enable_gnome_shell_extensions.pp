# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dconf::enable_gnome_shell_extensions
class dconf::enable_gnome_shell_extensions {
  datacat { 'enabled-gnome-shell-extensions':
    path     => '/etc/dconf/db/site.d/enabled-gnome-shell-extensions',
    template => 'profile/desktop/gnome_shell/enabled-gnome-shell-extensions.ini.erb',
  }
}
