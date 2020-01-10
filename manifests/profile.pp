# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dconf::profile { 'namevar': }
define dconf::profile (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String] $user_db = 'user',
  Optional[String] $service_db = undef,
  Optional[String] $system_db = undef,
  Array[String] $system_dbs = [],
  Stdlib::Absolutepath $dconf_config_dir = '/etc/dconf'
) {
  $all_system_dbs = unique([$system_db] + $system_dbs)
  $profile_file = "${dconf_config_dir}/profile/${name}"

  if $user_db {
    $user_db_line = "user-db:${user_db}"
  } else {
    $user_db_line = undef
  }
  if $service_db {
    $service_db_line = "service-db:${service_db}"
  } else {
    $service_db_line = undef
  }
  $system_db_lines = prefix($all_system_dbs, 'system-db:')

  $all_db_lines = delete_undef_values([$user_db_line, $service_db_line] + $system_db_lines + [''])

  $content = join($all_db_lines, "\n")

  file { $profile_file:
    ensure  => $ensure,
    content => $content,
  }
  file { [
    "${dconf_config_dir}/db/${name}.d",
    "${dconf_config_dir}/db/${name}.d/locks",
  ]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
