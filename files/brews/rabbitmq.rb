require 'formula'

class Rabbitmq < Formula
  homepage 'http://rabbitmq.org/'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v3.3.0/rabbitmq-server-mac-standalone-3.3.0.tar.gz'
  sha1 '1c30c30cae5c59e10100d2b034cfa6769198a140'

  version '3.3.0-boxen1'

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
