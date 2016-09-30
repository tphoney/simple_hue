source ENV['GEM_SOURCE'] || "https://rubygems.org"

gem 'rubocop'

group :acceptance do
  gem 'beaker-puppet_install_helper'
  gem 'rake'
  gem 'rototiller', '0.1.0'
  gem 'pry'
  gem 'faraday'
  gem 'puppetlabs_spec_helper'
  gem 'puppet', ENV['PUPPET_GEM_VERSION'] || '~> 4.0.0'
  gem 'facter', '>= 2.0'
  gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "beaker-testmode_switcher"
  gem 'beaker'
  gem 'master_manipulator'
  gem 'beaker-rspec'
  gem 'metadata-json-lint'
end

