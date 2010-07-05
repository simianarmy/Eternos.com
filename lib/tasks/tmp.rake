# $Id$
#
# Tasks for clearing caches

namespace :tmp do
  namespace :assets do 
    desc "Clears javascripts/cache and stylesheets/cache"
    task :clear => :environment do      
      FileUtils.rm(Dir['public/javascripts/cache/[^.]*'])
      FileUtils.rm(Dir['public/stylesheets/cache/[^.]*'])
    end
  end
  
  task :save_facebook_ids_from_log => :environment do
    ids = {}
    File.open("/home/mmauger/fb_uids.dump").each do |l|
        if l =~ /fb_sig_user"=>"(\d+)"/
          ids[$1] = true
        else
          puts "NO FB ID from\n\n#{l}"
        end
    end
    puts "Got #{ids.size} ids"
    ids.keys.each do |id|
      joined = Member.facebook_uid_eq(id).any? ? 1 : 0
      Member.connection.execute("INSERT IGNORE INTO facebook_ids (facebook_uid, joined) VALUES (#{id}, #{joined})")
    end
  end
end

