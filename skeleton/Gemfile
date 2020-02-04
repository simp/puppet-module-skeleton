# NOTE: SIMP Puppet rake tasks support ruby 2.4 - 2.5
# ------------------------------------------------------------------------------
gem_sources = ENV.fetch('GEM_SERVERS','https://rubygems.org').split(/[, ]+/)

ENV['PDK_DISABLE_ANALYTICS'] ||= 'true'

gem_sources.each { |gem_source| source gem_source }

group :test do
  puppet_version = ENV.fetch('PUPPET_VERSION', '~> 5.5')
  major_puppet_version = puppet_version.scan(/(\d+)(?:\.|\Z)/).flatten.first.to_i
  gem 'rake'
  gem 'puppet', puppet_version
  gem 'rspec'
  gem 'rspec-puppet'
  gem 'hiera-puppet-helper'
  gem 'puppetlabs_spec_helper'
  gem 'metadata-json-lint'
  gem 'puppet-strings'
  gem 'puppet-lint-empty_string-check',   :require => false
  gem 'puppet-lint-trailing_comma-check', :require => false
  gem 'simp-rspec-puppet-facts', ENV['SIMP_RSPEC_PUPPET_FACTS_VERSION'] || '~> 2.3'
  gem 'simp-rake-helpers', ENV['SIMP_RAKE_HELPERS_VERSION'] || '~> 5.8'
  gem( 'pdk', ENV['PDK_VERSION'] || '~> 1.0', :require => false) if major_puppet_version > 5
end

group :development do
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-doc'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-rspec'
  gem 'simp-beaker-helpers', ENV.fetch('SIMP_BEAKER_HELPERS_VERSION', '~> 1.13')
end
