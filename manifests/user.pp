# Public: Create rabbitmq user
#
# namevar - The name of the user
# password - Password for the new user. Defaults to empty.
#
# Examples
#
#    rabbitmq::user { 'foo': }
define rabbitmq::user(
  $ensure   = present,
  $password = ''
){
  require rabbitmq
  require rabbitmq::config

  if $ensure == 'present' {
    exec { "create rabbitmq user ${name}":
      command => "${rabbitmq::config::rabbitmqctl} add_user ${name} ${password}",
      unless  => "${rabbitmq::config::rabbitmqctl} list_users | grep -w ${name}",
      require => Service['dev.rabbitmq']
    }
  }
  elsif $ensure == 'absent' {
    exec { "delete rabbitmq user ${name}":
      command => "${rabbitmq::config::rabbitmqctl} delete_user ${name}",
      onlyif  => "${rabbitmq::config::rabbitmqctl} list_users | grep -w ${name}",
      require => Service['dev.rabbitmq']
    }
  }
}
