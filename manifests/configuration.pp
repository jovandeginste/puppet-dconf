# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dconf::configuration { 'namevar': }
define dconf::configuration (
  Hash[String, Hash[String, Any]] $configuration,
  String $root = $name,
  String $database = 'site',
  Enum['present', 'absent'] $ensure = 'present',
  Boolean $locked = false,
) {
  include ::dconf::update

  $safe_filename = regsubst($name, /[^[:alnum:]+]/, '_', 'G')
  $filename = "/etc/dconf/db/${database}.d/${safe_filename}"

  $ini_configuration = $configuration.reduce({}) |$cumulate, $element| {
    $subelement = $element[0]
    $sub_configuration = $element[1]
    $absolute =  "${root}/${subelement}"

    $sanitized_absolute = regsubst(regsubst(regsubst(
      $absolute, /\/+/, '/', 'G'),
      /^\//, '', 'G'),
      /\/$/, '', 'G')

    $parsed_configuration = $sub_configuration.map |$key, $value| {
      [$key, dconf::any_to_dconf_value($value)]
    }
    $cumulate.merge({$sanitized_absolute => $parsed_configuration})
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
