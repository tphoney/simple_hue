require 'master_manipulator'
require 'beaker'
require 'beaker-rspec' if ENV['BEAKER_TESTMODE'] != 'local'
require 'beaker/puppet_install_helper'
require 'beaker/testmode_switcher/dsl'

run_puppet_install_helper
hue_hostname = 'hampton'
hue_ip = '192.168.0.14'
hue_key = 'AVsa-nKtZOlssVKhBwM9MBVTVVUo11nSsGQPIm55'

RSpec.configure do |c|
  c.before :suite do
    unless ENV['BEAKER_TESTMODE'] == 'local'
      unless ENV['BEAKER_provision'] == 'no'

        hosts.each do |host|
          on(host, 'apt-get install -y puppetmaster')
          on(host, 'apt-get install -y vim')
          on(host, 'gem install faraday')
          on(host, 'gem install pry')
        end
      end

      proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
      hosts.each do |host|
        install_dev_puppet_module_on(host, :source => proj_root, :module_name => 'hue', :target_module_path => '/etc/puppet/modules')
        device_conf=<<-EOS
[#{hue_hostname}]
type hue
url http://#{hue_ip}/api/#{hue_key}
EOS
        create_remote_file(default, File.join(default[:puppetpath], "device.conf"), device_conf)
        on(host, "echo #{hue_ip} #{hue_hostname} >> /etc/hosts")
        apply_manifest("include hue")
        on master, puppet('plugin','download','--server',master.to_s)
        on master, puppet('device','-v','--waitforcert','0','--user','root','--server',master.to_s), {:acceptable_exit_codes => [0,1] }
        on master, puppet('cert','sign', hue_hostname), {:acceptable_exit_codes => [0,24] }
        site_pp=<<-EOS
node '#{hue_hostname}' {
  hue_light { '1':
    on => 'false',
  }
}
EOS
        create_remote_file(default, File.join(default[:puppetpath], "manifests/site.pp"), site_pp)
        on(host, "chmod 777 /etc/puppet/manifests/site.pp")
      end
    end

  end
end
