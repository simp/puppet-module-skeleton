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
CLEAN << TMP_DIR

if Rake.verbose
  puts "SKELETON_DIR    = '#{SKELETON_DIR}'"
  puts "PUPPET_CONF_DIR = '#{PUPPET_CONF_DIR}'"
end

def ensure_tmp
  FileUtils.mkdir_p PUPPET_CONF_DIR
  FileUtils.mkdir_p TMP_DIR
end


desc 'generate and test a basic module'
task :test do
  Rake::Task['test:generate'].invoke
  Rake::Task['test:test'].execute
end

namespace :test do
  desc 'generate test module'
  task :generate do
    FileUtils.rm_rf TMP_DIR
    ensure_tmp
    Dir.chdir TMP_DIR
    File.open( 'pupmod.answers', 'w' ){ |f| f.print ANSWERS }
    sh %Q{bundle exec puppet module generate simp-dummy --module_skeleton_dir=#{SKELETON_DIR} < 'pupmod.answers'}
  end


  desc 'run `bundle exec rake test` inside the generated module'
  task :test do
    ensure_tmp
    Dir.chdir TMP_DIR

    # Different versions of `puppet module generate` will produce a directory
    # with the name (changed since Puppet #21272/PUP-3124:
    mod_dir = ['dummy', 'simp-dummy'].select{ |x| File.directory? x }.first
    puts "==== '#{Dir.pwd}' '#{mod_dir}'"
    "#{File.expand_path(mod_dir)}"
    puts "==== Entering #{mod_dir}"
    Dir.chdir mod_dir

    env_globals = []
    ['PUPPET_VERSION', 'STRICT_VARIABLES', 'FUTURE_PARSER', 'TRUSTED_NODE_DATA'].each do |v|
      env_globals << %Q(#{v}="#{ENV[v]}") if ENV.key?( v )
    end
    env_globals_line = env_globals.join(' ')

    Bundler.with_clean_env do
      ['bundle','bundle exec rake test'].each do |cmd|
        line = "#{env_globals_line} #{cmd}"
        puts "==== EXECUTING: #{line}"
        result = system(line)
        exit 1 unless result
      end
    end
  end
end
