# Variables:
#
# SIMP_GEM_SERVERS | a space/comma delimited list of rubygem servers
# PUPPET_VERSION   | specifies the version of the puppet gem to load
puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['~>3']
gem_sources   = ENV.key?('SIMP_GEM_SERVERS') ? ENV['SIMP_GEM_SERVERS'].split(/[, ]+/) : ['https://rubygems.org']

gem_sources.each { |gem_source| source gem_source }



group :test do
  gem "rake"
  gem 'puppet', puppetversion
end



group :development do
  gem 'pry'
  gem 'pry-doc'
###   gem "travis"
###   gem "travis-lint"
end


### Dir.glob(File.join(File.dirname(__FILE__), 'tmp', '*', "Gemfile")) do |gemfile|
###   STDERR.puts "== '#{gemfile}'"
###   gemfile = IO.read(gemfile)
###   STDERR.puts '-'*80
###   STDERR.puts gemfile
###   STDERR.puts '-'*80
###   eval(gemfile, binding)
### end
