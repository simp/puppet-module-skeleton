require 'rake/clean'

ANSWERS = <<EOF
0.1.3
simp
Apache-2.0
A simple dnsmasq module designed to test the module skeleton.
https://github.com/simp/pupmod-simp-dnsmasq




EOF

SKELETON_DIR    = ENV.fetch( 'SKELETON_DIR',  File.expand_path('skeleton', File.dirname(__FILE__)) )
PUPPET_CONF_DIR = ENV.fetch( 'PUPPET_CONF_DIR',  %x{bundle exec puppet config print confdir}.chomp )
PUPPET_CONFIG   = ENV.fetch( 'PUPPET_CONF_DIR',  %x{bundle exec puppet config print config}.chomp )
TMP_DIR         = ENV.fetch( 'TMP_DIR', File.expand_path( 'tmp', File.dirname( __FILE__ )) )
BUNDLER_GEMFILE = ENV.fetch( 'BUNDLER_GEMFILE', './Gemfile' )
CLEAN << TMP_DIR

if Rake.verbose == true
  puts "SKELETON_DIR    = '#{SKELETON_DIR}'"
  puts "PUPPET_CONF_DIR = '#{PUPPET_CONF_DIR}'"
end

def ensure_tmp
  FileUtils.mkdir_p PUPPET_CONF_DIR
  FileUtils.mkdir_p TMP_DIR
end

def generate_module( name, answers_file=nil )
  cmd = "bundle exec puppet module generate #{name} --module_skeleton_dir=#{SKELETON_DIR}"
  if answers_file
    cmd = "#{cmd} < #{answers_file}"
  end
  sh %Q{#{cmd}}
end


task :default do
  sh %(rake -T)
end

desc 'generate a module using the skeleton'
task :generate,[:module_name] do |t,args|
  generate_module(args.module_name)
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
    generate_module('simp-dnsmasq','pupmod.answers')
  end


  desc 'run `bundle exec rake test` inside the generated module' +
       "\n\n\tEnvironment variables:\n" +
       "\t----------------------\n" +
       "\tSIMP_beaker_suites=yes   # include beaker suites [default: no]"
  task :test do
    ensure_tmp
    Dir.chdir TMP_DIR

    # Different versions of `puppet module generate` will produce a directory
    # with the name (changed since Puppet #21272/PUP-3124):
    mod_dir = ['dnsmasq', 'simp-dnsmasq'].select{ |x| File.directory? x }.first
    puts "==== '#{Dir.pwd}' '#{mod_dir}'"
    "#{File.expand_path(mod_dir)}"
    puts "==== Entering #{mod_dir}"
    Dir.chdir mod_dir

    # propagate relavent environment variables
    env_globals = []
    [
      'PUPPET_VERSION',
      'STRICT_VARIABLES',
      'TRAVIS',
      'CI',
    ].each do |v|
      env_globals << %Q(#{v}="#{ENV[v]}") if ENV.key?( v )
    end
    env_globals_line = env_globals.join(' ')

    Bundler.with_clean_env do
      cmds = ['bundle exec rake test']
      if ENV.fetch('SKELETON_beaker_suites','no') == 'yes'
        cmds << 'bundle exec rake beaker:suites[default]'
        _verb = 'with'
      end
      cmds = cmds.unshift "bundle --#{_verb||'without'} development system_tests"
      unless ENV.fetch('SKELETON_keep_gemfilie_lock','no') == 'yes'
        cmds = cmds.unshift "rm -f Gemfile.lock"
      end

      cmds.each do |cmd|
        line = "#{env_globals_line} #{cmd}"
        puts "==== EXECUTING: #{line}"
        exit 1 unless system(line)
      end
    end
  end
end
