# Public: Create RabbitMQ vhosts
#
# namevar - The name of the vhost
#
# Examples
#
#   rabbitmq::vhost { 'foo': }
define rabbitmq::vhost($ensure = present) {
  require rabbitmq
  require rabbitmq::config

  if $ensure == 'present' {
    exec { "create rabbitmq vhost ${name}":
      command => "${rabbitmq::config::rabbitmqctl} add_vhost ${name}",
      unless  => "${rabbitmq::config::rabbitmqctl} list_vhost | grep -w ${name}",
      require => Service['dev.rabbitmq']
    }
  }
  elsif $ensure == 'absent' {
    exec { "delete rabbitmq vhost ${name}":
      command => "${rabbitmq::config::rabbitmqctl} delete_vhost ${name}",
      onlyif  => "${rabbitmq::config::rabbitmqctl} list_vhost | grep -w ${name}",
      require => Service['dev.rabbitmq']
    }
  }
}
