require 'rake/clean'
require 'puppet'

ANSWERS = <<EOF
0.1.3
simp
Apache-2.0
A simple dnsmasq module designed to test the module skeleton.
https://github.com/simp/pupmod-simp-dnsmasq




EOF

SKELETON_DIR    = ENV.fetch( 'SKELETON_DIR',  File.expand_path('skeleton', File.dirname(__FILE__)) )
PUPPET_CONF_DIR = ENV.fetch( 'PUPPET_CONF_DIR',  %x{bundle exec puppet config print confdir}.chomp )
TMP_DIR         = ENV.fetch( 'TMP_DIR', File.expand_path( 'tmp', File.dirname( __FILE__ )) )
BUNDLER_GEMFILE = ENV.fetch( 'BUNDLER_GEMFILE', './Gemfile' )
CLEAN << TMP_DIR

if Rake.verbose == true
  puts "SKELETON_DIR    = '#{SKELETON_DIR}'"
  puts "PUPPET_CONF_DIR = '#{PUPPET_CONF_DIR}'"
end

def puppet_version
  require 'puppet'
  @puppet_version ||= Puppet.version
end

def module_cmd_puppet_version
  return @module_cmd_puppet_version if @module_cmd_puppet_version
  if puppet_version.split('.').first.to_i > 5
    @module_cmd_puppet_version = '~> 5.5.10'
  else
    @module_cmd_puppet_version = puppet_version
  end
end

def ensure_tmp
  FileUtils.mkdir_p PUPPET_CONF_DIR
  FileUtils.mkdir_p TMP_DIR
end

def bundle_exec_with_clean_env(cmds=[], env_globals = [])
  # propagate relavent environment variables
  [
    'PUPPET_VERSION',
    'STRICT_VARIABLES',
    'TRAVIS',
    'CI',
  ].each do |v|
    env_globals << %Q(#{v}="#{ENV[v]}") if ENV.key?( v )
  end

  yield cmds, env_globals if block_given?

  Bundler.with_clean_env do
    cmds.each do |cmd|
      line = "#{env_globals.join(' ')} #{cmd}"
      puts "==== EXECUTING: #{line}"
      exit 1 unless system(line)
    end
  end
end

def generate_module( name, answers_file=nil )
  cmd = "PUPPET_VERSION=\"#{module_cmd_puppet_version}\" " + \
    "bundle exec puppet module generate #{name} --module_skeleton_dir=#{SKELETON_DIR}"
  cmd = "#{cmd} < #{answers_file}" if answers_file
  cmds = [cmd]

  if module_cmd_puppet_version != puppet_version
    warn  "== PMT generate WORKAROUND: Setting PUPPET_VERSION='#{module_cmd_puppet_version}'"
    warn  "==   to run 'puppet module' (instead of PUPPET_VERSION='#{puppet_version}')"
    new_cmds = [ "PUPPET_VERSION=\"#{module_cmd_puppet_version}\" bundle update" ]
    cmds = new_cmds + cmds
  end

  bundle_exec_with_clean_env(cmds) do |_cmds, env_globals|
    env_globals.delete_if{|line| line =~ /^PUPPET_VERSION=/}
  end
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
    puts "==== Entering #{mod_dir}"
    Dir.chdir mod_dir

    test_cmds = [
        'bundle',
        'bundle exec rake check:dot_underscore',
        'bundle exec rake check:test_file',
        'bundle exec rake pkg:check_version',
        'bundle exec rake metadata_lint',
        'bundle exec rake pkg:compare_latest_tag',
        'bundle exec rake pkg:create_tag_changelog',
        'bundle exec rake lint',
        'bundle exec rake validate',
        'bundle exec rake test',
    ]
    if ENV.fetch('SKELETON_beaker_suites','no') == 'yes'
      test_cmds << 'bundle exec rake beaker:suites[default]'
      _verb = 'with'
    end
    test_cmds.unshift "bundle --#{_verb||'without'} development system_tests"

    unless ENV.fetch('SKELETON_keep_gemfile_lock','no') == 'yes'
      test_cmds.unshift "rm -f Gemfile.lock"
    end

    # Run module rake tests
    bundle_exec_with_clean_env test_cmds

    # Make sure module builds
    build_cmds = ( module_cmd_puppet_version != puppet_version ) ? \
      ['bundle exec rake build:pdk'] : ['bundle exec puppet module build']
    bundle_exec_with_clean_env(build_cmds)
  end
end
