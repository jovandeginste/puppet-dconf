# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dconf::configuration { 'namevar': }
define dconf::configuration (
  Hash[String, Hash[String, Any]] $configuration,
  String $root = $name,
  String $database = 'local',
  Enum['present', 'absent'] $ensure = 'present',
  Boolean $locked = false,
) {
  include ::dconf::update

  $safe_filename = regsubst($name, /[^[:alnum:]+]/, '_', 'G')
  $filename = "/etc/dconf/db/${database}.d/${safe_filename}"
  $locked_filename = "/etc/dconf/db/${database}.d/locks/${safe_filename}"

  if $locked {
    $locked_present = 'file'
  } else {
    $locked_present = 'absent'
  }

  $ini_configuration = $configuration.reduce({}) |$cumulate, $element| {
    $subelement = $element[0]
    $sub_configuration = $element[1]
    $absolute = "${root}/${subelement}"

    $sanitized_absolute = regsubst(regsubst(regsubst(
      $absolute, /\/+/, '/', 'G'),
      /^\//, '', 'G'),
      /\/$/, '', 'G')

      $parsed_configuration = $sub_configuration.map |$key, $value| {
        [$key, dconf::any_to_dconf_value($value)]
      }
      $cumulate.merge({$sanitized_absolute => $parsed_configuration})
  }

  $locked_content = $configuration.reduce([]) |$cumulate, $element| {
    $subelement = $element[0]
    $sub_configuration = $element[1]
    $absolute = "/${root}/${subelement}/"
    $parsed_configuration = prefix(keys($sub_configuration), $absolute)
    $cumulate + $parsed_configuration
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

  $locked_content_exp = [
    '# This file is managed by Puppet',
    '',
    sort($locked_content),
    '',
  ]

  file { $locked_filename:
    ensure  => $locked_present,
    content => join($locked_content_exp, "\n"),
    notify  => Class['dconf::update'],
  }
}
