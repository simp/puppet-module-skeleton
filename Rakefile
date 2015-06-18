require 'rake/clean'

ANSWERS = <<EOF
0.1.3
simp
Apache-2.0
A simple dummy module designed to test Travis.
https://github.com/simp/pupmod-simp-dummy




EOF

SKELETON_DIR    = ENV.fetch( 'SKELETON_DIR',  File.expand_path('skeleton', File.dirname(__FILE__)) )
PUPPET_CONF_DIR = ENV.fetch( 'PUPPET_CONF_DIR',  %x{bundle exec puppet config print confdir}.chomp )
PUPPET_CONFIG   = ENV.fetch( 'PUPPET_CONF_DIR',  %x{bundle exec puppet config print config}.chomp )
TMP_DIR         = ENV.fetch( 'TMP_DIR', File.expand_path( 'tmp', File.dirname( __FILE__ )) )
BUNDLER_GEMFILE = ENV.fetch( 'BUNDLER_GEMFILE', './Gemfile' )


if Rake.verbose
  puts "SKELETON_DIR    = '#{SKELETON_DIR}'"
  puts "PUPPET_CONF_DIR = '#{PUPPET_CONF_DIR}'"
end

def ensure_tmp
  FileUtils.mkdir_p PUPPET_CONF_DIR
  FileUtils.mkdir_p TMP_DIR
end


# FIXME: doesn't work, probably dangerous
desc 'generate module'
task :generate do
  FileUtils.rm_rf TMP_DIR
  ensure_tmp
  Dir.chdir TMP_DIR
  File.open( 'pupmod.answers', 'w' ){ |f| f.print ANSWERS }
  sh %Q{bundle exec puppet module generate simp-dummy --module_skeleton_dir=#{SKELETON_DIR} < 'pupmod.answers'}
end


desc 'test a generated module'
task :spec do
  ensure_tmp
  Dir.chdir TMP_DIR

  mod_dir = ['dummy', 'simp-dummy'].select{ |x| File.directory? x }.first
  puts "===== '#{Dir.pwd}' '#{mod_dir}'"
  "#{File.expand_path(mod_dir)}"
  puts "===== Entering #{mod_dir} (#{ENV['BUNDLER_GEMFILE']})"
  Dir.chdir mod_dir

  sh %Q{bundle exec rake validate}
end
