# Variables:
#
# GEM_SERVERS    | a space/comma delimited list of rubygem servers
# PUPPET_VERSION | specifies the version of the puppet gem to load
#
puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['~>4']
gem_sources   = ENV.fetch('GEM_SERVERS','https://rubygems.org').split(/[, ]+/)

gem_sources.each { |gem_source| source gem_source }

group :test do
  gem "rake"
  gem 'puppet', ENV.fetch('PUPPET_VERSION', '~>4.8.0') # Default to SIMP 6
end

group :development do
  gem 'pry'
  gem 'pry-doc'
end
