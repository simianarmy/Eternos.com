# $Id$
#
# Rake tasks for performing text processing & analysis on member data
# To be used for Tag clouds & other member infographics

# Module containing raw sql queries used to generate raw text associated with users
# It might make more sense to implement these in each AR class ...

module FullText
  ActivityStreamQuery =<<SQL
SELECT SQL_NO_CACHE activity_stream_items.author AS author, activity_stream_items.message AS message, activity_stream_items.attachment_data AS metadata, GROUP_CONCAT(DISTINCT IFNULL(tags.name, '') SEPARATOR ' ') AS tags, GROUP_CONCAT(DISTINCT IFNULL(comments.title, '') SEPARATOR ' ') AS comment_title, GROUP_CONCAT(DISTINCT IFNULL(comments.comment, '') SEPARATOR ' ') AS comment
FROM activity_stream_items
LEFT OUTER JOIN taggings ON (activity_stream_items.id = taggings.taggable_id AND taggings.taggable_type = 'ActivityStreamItem')  LEFT OUTER JOIN tags ON (tags.id = taggings.tag_id) AND taggings.context = 'tags'   LEFT OUTER JOIN comments ON comments.commentable_id = activity_stream_items.id AND comments.commentable_type = 'ActivityStreamItem'
WHERE activity_stream_id = ? AND deleted_at IS NULL
GROUP BY  activity_stream_items.id
SQL

  FeedQuery=<<SQL
SELECT SQL_NO_CACHE feed_entries.author AS author, feed_entries.name AS name, feed_entries.summary AS summary, feed_contents.html_content AS raw_content, feed_entries.url AS url, feed_entries.categories AS categories, GROUP_CONCAT(DISTINCT IFNULL(tags.name, '') SEPARATOR ' ') AS tags, GROUP_CONCAT(DISTINCT IFNULL(comments.title, '') SEPARATOR ' ') AS comment_title, GROUP_CONCAT(DISTINCT IFNULL(comments.comment, '') SEPARATOR ' ') AS comment
FROM feed_entries
LEFT OUTER JOIN feed_contents ON feed_contents.feed_entry_id = feed_entries.id   LEFT OUTER JOIN taggings ON (feed_entries.id = taggings.taggable_id AND taggings.taggable_type = 'FeedEntry')  LEFT OUTER JOIN tags ON (tags.id = taggings.tag_id) AND taggings.context = 'tags'   LEFT OUTER JOIN comments ON comments.commentable_id = feed_entries.id AND comments.commentable_type = 'FeedEntry'
WHERE feed_entries.feed_id IN (?) AND deleted_at IS NULL
GROUP BY feed_entries.id
SQL

  PhotoAlbums=<<SQL
SELECT SQL_NO_CACHE backup_photo_albums.name AS name, backup_photo_albums.description AS description, backup_photo_albums.location AS location
FROM backup_photo_albums
WHERE backup_source_id IN (?) AND deleted_at IS NULL
GROUP BY backup_photo_albums.id
SQL
 
  Contents=<<SQL
SELECT SQL_NO_CACHE contents.title AS title, contents.filename AS filename, contents.description AS description, GROUP_CONCAT(DISTINCT IFNULL(tags.name, '') SEPARATOR ' ') AS tags, GROUP_CONCAT(DISTINCT IFNULL(comments.title, '') SEPARATOR ' ') AS comment_title, GROUP_CONCAT(DISTINCT IFNULL(comments.comment, '') SEPARATOR ' ') AS comment
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

# Helper to convert MysqlResult into text string
# Apply some basic filtering to strip out junk data
def get_sql_result_str(mysql_res)
  mysql_res.fetch_row.compact.reject {|s| s.blank? || (s == "0")}.join(' ') rescue ''
end
  
# [re]Creates MyISAM table for user's text data
# Drops existing table 1st
def create_text_table(table, text)
  @conn.execute("DROP TABLE IF EXISTS #{table}")
  @conn.execute("CREATE TABLE #{table} (txt TEXT NOT NULL, FULLTEXT (txt)) ENGINE = MYISAM")
  @conn.execute("INSERT INTO #{table} VALUES ('#{@conn.quote_string(text)}')")
end

def remove_table(table)
  @conn.execute("DROP TABLE #{table}")
end

# Peforms sql queries on user records, returns all results as single string
def user_text_dump(user)
  returning String.new do |txt|
    res = []
    res << get_sql_result_str(@conn.execute(FullText::ActivityStreamQuery.gsub(/\?/, user.activity_stream.id.to_s)))
   
    if (feed_ids = user.backup_sources.blog.map(&:id)).any?
      res << get_sql_result_str(@conn.execute(FullText::FeedQuery.gsub(/\?/, feed_ids.join(','))))
    end
    if (albums_ids = BackupPhotoAlbum.by_user(user.id).map(&:backup_source_id).uniq).any?
      res << get_sql_result_str(@conn.execute(FullText::PhotoAlbums.gsub(/\?/, albums_ids.join(','))))
    end
    res << get_sql_result_str(@conn.execute(FullText::Contents.gsub(/\?/, user.id.to_s)))
    txt << res.join(' ')
    puts "result: #{txt}"
  end
end

# Performs text analysis on some data store & returns word-count stats
# as sorted array of tuples [word, frequency]
# Sorted by frequency descending
def analyze_text(table)
  returning Array.new do |wc|
    @myisam_ftpdump ||= `which myisam_ftdump`.strip
    @mysql_db_dir ||= File.join(@conn.instance_variable_get("@config")[:db_dir], @conn.instance_variable_get("@config")[:database])
    ftdump = `#{@myisam_ftpdump} -c #{@mysql_db_dir}/#{table} 0`
    ftdump.split("\n").each do |ws|
      parts = ws.split(/\s+/)
      puts parts.inspect
      wc << [parts[3], parts[1].to_i]
    end
  end
end

namespace :analysis do
  # Must be run on the database server host for myisam_ftdump command
  desc "Creates new text dump for all users"
  task :update_fulltext => :environment do
    include FullText
    # Global database connection
    @conn = ActiveRecord::Base.connection
    
    # Per-user task
    User.active.find_each do |u|
      # Create MyISAM table with full text index for the user
      puts "Creating text dump table for user #{u.id}..."
      text = user_text_dump(u)
      unless text.blank?
        tbl = "ft_#{u.id}"
        puts "Processing table #{tbl}..."
        create_text_table(tbl, text)
        # Run myisam_ftdump on the table to get word stats
        stats = analyze_text(tbl)
        puts stats.inspect
        # Remove temp table
        remove_table(tbl)
        # Add word stats to user text table
        if rt = RawText.find_or_create_by_user_id(u.id)
          rt.update_attribute(:word_counts, stats)
        end
      end
    end
  end
end
  