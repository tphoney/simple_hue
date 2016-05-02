require 'rake'

# We clear the Beaker rake tasks from spec_helper as they assume
# rspec-puppet and a certain filesystem layout
Rake::Task[:beaker_nodes].clear
Rake::Task[:beaker].clear

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance => [:spec_prep]) do |t|
  ENV['BEAKER_PE_DIR'] = ENV['BEAKER_PE_DIR'] || 'http://enterprise.delivery.puppetlabs.net/2015.3/preview/'
  ENV['BEAKER_set'] = ENV['BEAKER_set']
  t.pattern = 'spec/acceptance'
end

namespace :acceptance do
  desc "Run acceptance tests for with PE 2015.3"
  RSpec::Core::RakeTask.new("default".to_sym => [:spec_prep]) do |t|
    ENV['BEAKER_PE_DIR'] = 'http://enterprise.delivery.puppetlabs.net/2015.3/preview/'
    ENV['BEAKER_keyfile'] = '~/.ssh/id_rsa-acceptance' if ns == :pooler
    ENV['BEAKER_debug'] = true if ENV['BEAKER_DEBUG']
    ENV['BEAKER_set'] = 'default'
    t.pattern = 'spec/acceptance'
  end
end
