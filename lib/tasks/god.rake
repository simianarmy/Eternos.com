require 'erb'

namespace :god do
  desc "Parse the god config template into a god config file"
  task :generate => :environment do
    name = 'daemons'

    File.open( "#{RAILS_ROOT}/config/#{name}.god", "w+" ) do |f|
      t = File.read( "#{RAILS_ROOT}/config/#{name}.god.erb" )
      f.write( ERB.new( t ).result( binding )  )
    end

    puts "god config generated in config/#{name}.god"
  end
end