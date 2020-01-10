# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dconf::gnome_shell_extension { 'namevar': }
define dconf::gnome_shell_extension (
  Hash[String, Any] $configuration,
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String] $database = undef,
  Boolean $lockdown = false,
  Boolean $enabled = true,
) {
  include ::dconf::enable_gnome_shell_extensions
  dconf::configuration { $name:
    ensure        => $ensure,
    configuration => $configuration,
    file          => $name,
    database      => $database,
  }

  datacat_fragment { "enable-gnome-shell-extension:${name}":
    target => 'enabled-gnome-shell-extensions',
    data   => {
      $name => $enabled,
    },
  }
}
