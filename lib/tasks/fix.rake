# Fixes for fuckups
namespace :fix do
  desc 'Find & fix photos in the wrong albums'
  task :fix_mismatched_album_photos => :environment do
    Album.all.each do |album|
      puts "Album #{album.id} for user #{album.user_id}"
      wrong = album.photos.user_id_ne(album.user_id)
      if wrong.any?
        puts "#{wrong.size} mismatched photos in album #{album.id}"
        sorted = wrong.group_by(&:user_id)
        sorted.each do |uid, set|
          puts "#{set.size} photos for user #{uid}"
          album_date = set[0].taken_at || set[0].created_at
          
          al = Album.find_or_create_by_name_and_user_id(album_date.to_date.to_s, uid)
          puts "Found or created album #{al.inspect}"
          al.cover_id ||= set[0].id
          al.save(false)
          
          set.each do |photo|
            photo.collection = al
            al.increment! :size
            photo.save(false)
          end
        end
      end
    end
  end
  
  desc 'Assign backup photos\' comments to their associated photo objects'
  task :fix_unsynched_backup_photo_comments => :environment do
    Comment.commentable_type_eq('BackupPhoto').all(:group => :commentable_id).each do |comm|
      if (bp = comm.commentable) && bp.photo
        puts "Saving comments from backup photo #{bp.id} to photo object"
        bp.photo.comments = bp.comments
      end
    end
  end  
  
  desc 'Update facebook backup source records to FacebookAccount STI class'
  task :convert_fb_backup_sources_to_facebook_account => :environment do
    # Can't use named scope, returns read-only objects.  Instead get ids and iterate with find
    bs_ids = BackupSource.facebook.map(&:id)
    BackupSource.find(:all, bs_ids).each do |bs|
      bs[:type] = 'FacebookAccount'
      bs.save(false)
    end
  end
end