require 'master_manipulator'
require 'beaker'
require 'beaker-rspec' if ENV['BEAKER_TESTMODE'] != 'local'
require 'beaker/puppet_install_helper'
require 'beaker/testmode_switcher/dsl'

run_puppet_install_helper
hue_ip = '192.168.0.14'
hue_key = 'AVsa-nKtZOlssVKhBwM9MBVTVVUo11nSsGQPIm55'

RSpec.configure do |c|
  c.before :suite do
    unless ENV['BEAKER_TESTMODE'] == 'local'
      unless ENV['BEAKER_provision'] == 'no'

        hosts.each do |host|
          on(host, 'apt-get install -y vim')
          on(host, 'gem install faraday')
          on(host, 'gem install pry')
        end
      end

      proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
      hosts.each do |host|
        install_dev_puppet_module_on(host, :source => proj_root, :module_name => 'hue', :target_module_path => '/etc/puppet/modules')
        apply_manifest("include hue")
      end
    end

  end
end
