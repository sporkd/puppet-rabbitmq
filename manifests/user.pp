# Public: Create rabbitmq user
#
# namevar - The name of the user
# password - Password for the new user. Defaults to empty.
#
# Examples
#
#    rabbitmq::user { 'foo': }
define rabbitmq::user(
  $password,
  $ensure = present,
  $tags   = 'administrator'
){
  require rabbitmq
  require rabbitmq::config

  if $ensure == 'present' {
    exec { "create rabbitmq user ${name}":
      command => "${rabbitmq::config::rabbitmqctl} add_user ${name} ${password} && ${rabbitmq::config::rabbitmqctl} set_user_tags ${name} administrator",
      unless  => "${rabbitmq::config::rabbitmqctl} list_users | grep -w ${name}",
      require => Exec['wait-for-rabbitmq']
    }
  }
  elsif $ensure == 'absent' {
    exec { "delete rabbitmq user ${name}":
      command => "${rabbitmq::config::rabbitmqctl} delete_user ${name}",
      onlyif  => "${rabbitmq::config::rabbitmqctl} list_users | grep -w ${name}",
      require => Exec['wait-for-rabbitmq']
    }
  }
}
