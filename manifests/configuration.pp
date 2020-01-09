# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dconf::configuration { 'namevar': }
define dconf::configuration (
  Hash[String, Any] $configuration,
  String $file = $name,
  Enum['system', 'user'] $database_type = 'system',
  String $database = 'local',
  Enum['present', 'absent'] $ensure = 'present',
) {
  if $database_type == 'system' {
    $safe_filename = regsubst($file, /[^[:alnum:]+]/, '_', 'G')
    $filename = "/etc/dconf/db/${database}.d/${safe_filename}"
    $ini_configuration = {
      $name => $configuration,
    }
    $ini_settings = {
    }
    $content = create_ini_settings($ini_configuration, $ini_settings)

    ini_setting { $filename:
      ensure  => $ensure,
      content => $content,
    }
  } else {
  }
}
