# $Id$
#
# One-off & db maintenance tasks

namespace :db do
  desc "Removes facebook activity stream item duplicates"
  task :strip_fb_as_dupes => :environment do
    #res = FacebookActivityStreamItem.connection.execute("select count(concat(published_at,message)) AS num, id FROM activity_stream_items where type = 'FacebookActivityStreamItem' GROUP BY published_at,message HAVING ( COUNT(concat(published_at,message)) > 1 )") 
    FacebookActivityStreamItem.find(:all, :group => "published_at,message HAVING ( COUNT(concat(published_at,activity_stream_id,message)) > 1 )").each do |fb|
      #puts "#{fb.activity_stream_id}, #{fb.guid}, #{fb.published_at}, #{fb.message}"
      # Fetch all results matching these attributes
      dupes = FacebookActivityStreamItem.find(:all, :conditions => {:activity_stream_id => fb.activity_stream_id, 
        :guid => fb.guid, 
        :published_at => fb.published_at, 
        :message => fb.message
        })
      next if dupes.size == 1
      # Keep 1st..remove the rest
      dupes.each do |d|
        puts "#{d.id} => #{d.activity_stream_id}, #{d.guid}, #{d.published_at}, #{d.message}\n"
      end      
      dupes.shift
      puts "Deleting records #{dupes.map(&:id).join(',')}"
      #FacebookActivityStreamItem.delete(dupes.map(&:id))
      puts '*' * 40
    end
  end
end

  