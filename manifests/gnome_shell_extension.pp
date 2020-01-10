# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dconf::gnome_shell_extension { 'namevar': }
define dconf::gnome_shell_extension (
  Hash[String, Any] $configuration = {},
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String] $database = undef,
  Boolean $enabled = true,
) {
  include ::dconf::enable_gnome_shell_extensions

  [$extension_name, $extension_author] = split($name, '@')

  if empty($configuration) {
    $dconf_file_ensure = 'absent'
  } else {
    $dconf_file_ensure = $ensure
  }

  dconf::configuration { $name:
    ensure        => $dconf_file_ensure,
    configuration => { $extension_name => $configuration },
    root          => 'org/gnome/shell/extensions',
    database      => $database,
  }

  datacat_fragment { "enable-gnome-shell-extension:${name}":
    target => 'enabled-gnome-shell-extensions',
    data   => {
      $name => $enabled,
    },
  }
}
