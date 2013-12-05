# Public: Create RabbitMQ vhosts
#
# namevar - The name of the vhost
#
# Examples
#
#   rabbitmq::vhost { 'foo': }
define rabbitmq::vhost($ensure = present) {
  require rabbitmq

  $rabbitmqctl = "$::boxen_home/sbin/rabbitmqctl"

  if $ensure == 'present' {
    exec { "create rabbitmq vhost ${name}":
      command => "${rabbitmqctl} add_vhost ${name}",
      unless  => "${rabbitmqctl} list_vhost | grep -w ${name}",
      require => Service['dev.rabbitmq']
    }
  }
  elsif $ensure == 'absent' {
    exec { "delete rabbitmq vhost ${name}":
      command => "${rabbitmqctl} delete_vhost ${name}",
      onlyif  => "${rabbitmqctl} list_vhost | grep -w ${name}",
      require => Service['dev.rabbitmq']
    }
  }
}
