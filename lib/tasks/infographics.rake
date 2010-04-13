# $Id$
#
# Rake tasks for performing text processing & analysis on member data
# To be used for Tag clouds & other member infographics

# Module containing raw sql queries used to generate raw text associated with users
# It might make more sense to implement these in each AR class ...

module FullText
  ActivityStreamQuery =<<SQL
SELECT SQL_NO_CACHE activity_stream_id, activity_stream_items.author AS author, activity_stream_items.message AS message, activity_stream_items.attachment_data AS metadata, GROUP_CONCAT(DISTINCT IFNULL(tags.name, '0') SEPARATOR ' ') AS tags, GROUP_CONCAT(DISTINCT IFNULL(comments.title, '0') SEPARATOR ' ') AS comment_title, GROUP_CONCAT(DISTINCT IFNULL(comments.comment, '0') SEPARATOR ' ') AS comment
FROM activity_stream_items
LEFT OUTER JOIN taggings ON (activity_stream_items.id = taggings.taggable_id AND taggings.taggable_type = 'ActivityStreamItem')  LEFT OUTER JOIN tags ON (tags.id = taggings.tag_id) AND taggings.context = 'tags'   LEFT OUTER JOIN comments ON comments.commentable_id = activity_stream_items.id AND comments.commentable_type = 'ActivityStreamItem'
WHERE activity_stream_id = ? AND deleted_at IS NULL
GROUP BY  activity_stream_items.id
SQL

  FeedQuery=<<SQL
SELECT SQL_NO_CACHE feed_entries.id AS id , feed_entries.author AS author, feed_entries.name AS name, feed_entries.summary AS summary, feed_contents.html_content AS raw_content, feed_entries.url AS url, feed_entries.categories AS categories, GROUP_CONCAT(DISTINCT IFNULL(tags.name, '0') SEPARATOR ' ') AS tags, GROUP_CONCAT(DISTINCT IFNULL(comments.title, '0') SEPARATOR ' ') AS comment_title, GROUP_CONCAT(DISTINCT IFNULL(comments.comment, '0') SEPARATOR ' ') AS comment
FROM feed_entries
LEFT OUTER JOIN feed_contents ON feed_contents.feed_entry_id = feed_entries.id   LEFT OUTER JOIN taggings ON (feed_entries.id = taggings.taggable_id AND taggings.taggable_type = 'FeedEntry')  LEFT OUTER JOIN tags ON (tags.id = taggings.tag_id) AND taggings.context = 'tags'   LEFT OUTER JOIN comments ON comments.commentable_id = feed_entries.id AND comments.commentable_type = 'FeedEntry'
WHERE feed_entries.feed_id IN (?) AND deleted_at IS NULL
GROUP BY feed_entries.id
SQL

  PhotoAlbums=<<SQL
SELECT SQL_NO_CACHE backup_photo_albums.id AS id , backup_photo_albums.name AS name, backup_photo_albums.description AS description, backup_photo_albums.location AS location
FROM backup_photo_albums
WHERE backup_source_id IN (?) AND deleted_at IS NULL
GROUP BY backup_photo_albums.id
SQL
 
  Contents=<<SQL
SELECT SQL_NO_CACHE contents.id AS id , contents.title AS title, contents.filename AS filename, contents.description AS description, GROUP_CONCAT(DISTINCT IFNULL(tags.name, '0') SEPARATOR ' ') AS tags, GROUP_CONCAT(DISTINCT IFNULL(comments.title, '0') SEPARATOR ' ') AS comment_title, GROUP_CONCAT(DISTINCT IFNULL(comments.comment, '0') SEPARATOR ' ') AS comment
FROM contents
LEFT OUTER JOIN taggings ON (contents.id = taggings.taggable_id AND taggings.taggable_type = 'Content')  LEFT OUTER JOIN tags ON (tags.id = taggings.tag_id) AND taggings.context = 'tags'   LEFT OUTER JOIN comments ON comments.commentable_id = contents.id AND comments.commentable_type = 'Content'
WHERE contents.user_id = ? AND deleted_at IS NULL
GROUP BY contents.id
SQL
end
  
# How to use thinking_sphinx riddle config-building snippet to generate sql queries for text dumps
def generate_text_sql
  ThinkingSphinx.context.indexed_models.each do |model|
    model = model.constantize
    model.define_indexes
    model.sphinx_indexes.each do |idx|
      idx.sources.each do |src|
        puts "#{model.to_s} SQL => "
        puts src.to_sql
      end
    end
  end
end

namespace :infographics do
  desc "Creates new text dump for all users"
  task :update_fulltext => :environment do
    # Per-user task
    User.active.find_each do |u|
      if raw = RawText.find_by_user_id(u.id)
        latest = raw.updated_at
      else
        latest = u.created_at
      end
      puts "Updating text dump for user #{u.id} since #{latest}..."

      puts FullText::ActivityStreamQuery.gsub(/\?/, u.activity_stream.id.to_s)
      puts FullText::FeedQuery.gsub(/\?/, u.backup_sources.blog.map(&:id).join(','))
      puts FullText::PhotoAlbums.gsub(/\?/, BackupPhotoAlbum.by_user(u.id).map(&:backup_source_id).uniq.join(','))
      puts FullText::Contents.gsub(/\?/, u.id.to_s)
      #res = ActiveRecord::Base.connection.execute(sql)
      break
    end
  end
end
  