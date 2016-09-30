require 'rake'
require 'rototiller'
# We clear the Beaker rake tasks from spec_helper as they assume
# rspec-puppet and a certain filesystem layout
Rake::Task[:beaker_nodes].clear
Rake::Task[:beaker].clear

rototiller_task :spec_prep do |t|
  t.add_env({:name => 'BEAKER_PE_DIR',
             :message => 'Puppet Enterprise source directory',
             :default => 'http://enterprise.delivery.puppetlabs.net/2015.3/preview/'})

  t.add_env({:name => 'BEAKER_debug',
             :message => 'Beaker debug level',
             :default => 'false'})

  t.add_env({:name => 'BEAKER_set',
             :message => 'Beaker set. This defines what beaker nodeset will be used for the test',
             :default => "default"})

  t.add_env({:name => 'BEAKER_keyfile',
             :message => 'The keyfile is the rsa pem file used to connect to the vm test instances',
             :default => '~/.ssh/id_rsa-acceptance'})

  t.add_env({:name => 'HUE_IP',
             :message => 'HUE_IP environment variable is not set, set using \'export HUE_IP=1.1.1.1\' where 1.1.1.1 is the ip of your hue hub',
             })

  t.add_env({:name => 'HUE_KEY',
             :message => 'HUE_KEY environment variable is not set, set using \'export HUE_KEY=key_thing\' where key_thing is a developer key for your hue hub',
             })
end


desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance => [:spec_prep]) do |t|
  t.pattern = 'spec/acceptance'
end
