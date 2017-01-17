require 'master_manipulator'
require 'beaker'
require 'beaker-rspec' if ENV['BEAKER_TESTMODE'] != 'local'
require 'beaker/puppet_install_helper'
require 'beaker/testmode_switcher/dsl'

run_puppet_install_helper
hue_ip = ENV['HUE_IP']
hue_key = ENV['HUE_KEY']

def beaker_opts
  @env ||= {
    debug: true,
    trace: true,
    environment: {
      'HUE_IP' => ENV['HUE_IP'],
      'HUE_KEY' => ENV['HUE_KEY'],
    }
  }
end

RSpec.configure do |c|
  c.before :suite do
    unless ENV['BEAKER_TESTMODE'] == 'local'
      unless ENV['BEAKER_provision'] == 'no'

        hosts.each do |host|
          on(host, 'apt-get install -y vim')
          on(host, '/opt/puppetlabs/puppet/bin/gem install faraday')
          on(host, '/opt/puppetlabs/puppet/bin/gem install pry')
          on(host, "echo export HUE_KEY=#{hue_key} >> /root/.bashrc")
          on(host, "echo export HUE_IP=#{hue_ip} >>  /root/.bashrc")
          on(host, 'source  /root/.bashrc')
          on(host, '.  /root/.bashrc')
        end
      end

      proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
      hosts.each do |host|
        install_dev_puppet_module_on(host, :source => proj_root, :module_name => 'hue', :target_module_path => '/etc/puppetlabs/code/modules')
        on(host, "whoami; pwd; echo #{hue_ip}")
      end
    end
  end
end
