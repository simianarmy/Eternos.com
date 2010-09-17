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
end