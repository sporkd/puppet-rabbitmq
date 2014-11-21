require 'formula'

class Rabbitmq < Formula
  homepage 'http://rabbitmq.org/'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v3.4.1/rabbitmq-server-mac-standalone-3.4.1.tar.gz'
  sha1 'f1cf93cbfe7d5b12d426819c890f9b688868180a'

  version '3.4.1-boxen1'

  def install
    # Install the base files
    prefix.install Dir['*']

    # Replace the SYS_PREFIX for things like rabbitmq-plugins
    inreplace sbin / 'rabbitmq-defaults' do |s|
      s.gsub! 'SYS_PREFIX=${RABBITMQ_HOME}', "SYS_PREFIX=#{HOMEBREW_PREFIX}"
      s.gsub! 'CLEAN_BOOT_FILE="${SYS_PREFIX}', "CLEAN_BOOT_FILE=\"#{prefix}"
      s.gsub! 'SASL_BOOT_FILE="${SYS_PREFIX}', "SASL_BOOT_FILE=\"#{prefix}"
    end

    inreplace((sbin + 'rabbitmq-env'), 'RABBITMQ_HOME="${SCRIPT_DIR}/.."', "RABBITMQ_HOME=#{prefix}")
  end
end
