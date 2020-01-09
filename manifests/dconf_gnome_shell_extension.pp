# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dconf::dconf_gnome_shell_extension { 'namevar': }
define dconf::dconf_gnome_shell_extension (
  Hash[String, Any] $configuration,
  Enum['present', 'absent'] $ensure = 'present',
  Enum['system', 'user'] $type = 'system',
  Boolean $lockdown = false
) {
  dconf::configuration { "${type}/${name}":
    ensure        => $ensure,
    configuration => $configuration,
    file          => $name,
    database_type => $type,
  }
}
