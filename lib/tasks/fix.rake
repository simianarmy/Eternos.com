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
  
  def fix_backup_source_type(ids, type)
    BackupSource.find(ids).each do |bs|
      bs[:type] = type
      bs.save(false)
    end
  end
  
  desc 'Update facebook backup source records to FacebookAccount STI class'
  task :fix_backup_source_types => :environment do
    # Can't use named scope, returns read-only objects.  Instead get ids and iterate with find
    bs_ids = BackupSource.facebook.map(&:id)
    fix_backup_source_type(bs_ids, 'FacebookAccount')
    bs_ids = BackupSource.twitter.map(&:id)
    fix_backup_source_type(bs_ids, 'BackupSource')
    bs_ids = BackupSource.gmail.map(&:id)
    fix_backup_source_type(bs_ids, 'GmailAccount')
    bs_ids = BackupSource.blog.map(&:id)
    fix_backup_source_type(bs_ids, 'FeedUrl')
    bs_ids = BackupSource.picasa.map(&:id)
    fix_backup_source_type(bs_ids, 'PicasaWebAccount')
  end
  
  desc 'Imports facebook auth credentials from members table to FacebookAccount record'
  task :import_fb_backup_auth_creds_to_facebook_account => :environment do
    bs_ids = BackupSource.facebook.map(&:id)
    BackupSource.find(bs_ids).each do |bs|
      next unless user = bs.member
      bs[:type] ||= 'FacebookAccount'
      if bs.auth_token.blank? || bs.auth_secret.blank?
        bs.auth_login ||= user.facebook_id
        bs.set_facebook_session_keys(user.facebook_session_key, user.facebook_secret_key)
      end
      bs.save(false)
      puts "Saved fb account with fb creds: #{bs.inspect}"
    end
  end
end