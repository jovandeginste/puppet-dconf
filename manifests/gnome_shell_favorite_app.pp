# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dconf::gnome_shell_favorite_app { 'namevar': }
define dconf::gnome_shell_favorite_app (
  Boolean $enabled = true,
) {
  include ::dconf::enable_gnome_shell_favorite_apps

  datacat_fragment { "enable-gnome-shell-favorite_app:${name}":
    target => 'enabled-gnome-shell-favorite_apps',
    data   => {
      $name => $enabled,
    },
  }
}
