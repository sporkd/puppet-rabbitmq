define rabbitmq::user::grant(
  $user,
  $vhost,
  $ensure      = 'present',
  $permissions = '".*" ".*" ".*"'
){
  require rabbitmq
  require rabbitmq::config

  if $ensure == 'present' {
    exec { "grant user ${name} right ${permissions} on vhost ${vhost}":
      command => "${rabbitmq::config::rabbitmqctl} set_permissions -p ${vhost} ${user} ${permissions}",
      unless  => "${rabbitmq::config::rabbitmqctl} list_permissions -p ${vhost} ${user}",
      require => Service['dev.rabbitmq']
    }
  }
  elsif $ensure == 'absent' {
    exec { "revoke permissions from user ${name} on vhost ${vhost}":
      command => "${rabbitmq::config::rabbitmqctl} clear_permissions -p ${vhost} ${user}",
      onlyif  => "${rabbitmq::config::rabbitmqctl} list_permissions -p ${vhost} ${user}",
      require => Service['dev.rabbitmq']
    }
  }
}


