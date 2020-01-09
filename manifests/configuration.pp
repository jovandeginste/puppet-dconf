# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dconf::configuration { 'namevar': }
define dconf::configuration (
  Hash[String, Hash[String, Any]] $configuration,
  String $file = $name,
  String $database = 'site',
  Enum['present', 'absent'] $ensure = 'present',
) {
  include ::dconf::update

  $safe_filename = regsubst($file, /[^[:alnum:]+]/, '_', 'G')
  $filename = "/etc/dconf/db/${database}.d/${safe_filename}"

  $ini_configuration = $configuration.reduce({}) |$cumulate, $element| {
    $subelement = $element[0]
    $sub_configuration = $element[1]
    $absolute = $subelement ? {
      '/'     => $name,
      default => "${name}/${subelement}",
    }
    $parsed_configuration = $sub_configuration.map |$key, $value| {
      [$key, dconf::any_to_dconf_value($value)]
    }
    $cumulate.merge({$absolute => $parsed_configuration})
  }

  $ini_settings = {
    'quote_char' => '',
  }
  $content = hash2ini($ini_configuration, $ini_settings)

  file { $filename:
    ensure  => $ensure,
    content => $content,
    notify  => Class['dconf::update'],
  }
}
