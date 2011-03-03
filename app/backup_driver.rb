# Test script for driving backup workers from the command line.

# Load rails environment gemfile
require 'rubygems'
require 'activesupport'
require 'optparse'

# This hash will hold all of the options
# parsed from the command-line by
# OptionParser.
options = {}

optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: backup_driver.rb -r rails-app-dir -b backup-site -u user-id"

  # Define the options, and what they do
  options[:verbose] = false
  opts.on( '-v', '--verbose', 'Output more information' ) do
    @verbose = options[:verbose] = true
  end

  options[:logfile] = nil
  opts.on( '-l', '--logfile FILE', 'Write log to FILE' ) do |file|
    options[:logfile] = file
    @logger = Logger.new(file)
  end

  options[:rails_root] = nil
  opts.on( '-r', '--rails-root DIR', 'Path to Rails app') do |root|
    RAILS_ROOT = options[:rails_root] = root
  end
  
  options[:backup_site] = nil
  opts.on( '-b', '--site SITE', 'Select backup site.  One of [email|facebook|picasa|rss|twitter|linkedin]') do |site|
    options[:backup_site] = site if Workers.has_key?(site)
  end
  
  options[:user_id] = nil
  opts.on( '-u', '--user ID', 'User ID') do |uid|
    options[:user_id] = uid
  end
  
  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!

puts options.inspect
unless options[:rails_root] && options[:backup_site] && options[:user_id]
  puts "Missing args.  Run with -h for options." 
  exit
end

# Run the backup
$: << RAILS_ROOT
Dir[File.expand_path(File.join(File.dirname(__FILE__), 'workers', '**','*.rb'))].each {|f| require f}
require File.join(RAILS_ROOT, 'config/environment.rb')

Workers = {
  'linkedin'   => BackupWorker::Linkedin
}

user = nil
unless user = User.find_by_id(options[:user_id])
  puts "Could not find user with ID = #{options[:user_id]}"
  exit
end
say "Running backup for #{options[:backup_site]} site, user #{user.id}"
# Get user's backup source object
backup_source = nil
case options[:backup_site]
when 'linkedin'
  backup_source = user.backup_sources.linkedin.first
end
unless backup_source
  puts "Could not find a #{options[:backup_site]} backup site for user!"
  exit
end

# Create the backup source job
job = BackupSourceJob.create(
  :backup_job_id      => rand(1000),
  :backup_source_id   => backup_source.id,
  :backup_data_set_id => EternosBackup::SiteData.defaultDataSet,
  :status             => BackupStatus::Running)

worker = Workers[options[:backup_site]].new(job)

mark = Benchmark.measure do
  worker.run
end
say "Backup time: #{mark}"
say "Done."

### 

def say(msg)
  puts msg, "\n" if @verbose
  @logger.info(msg) if @logger
end