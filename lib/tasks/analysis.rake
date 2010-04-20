# $Id$
#
# Rake tasks for performing text processing & analysis on member data
# To be used for Tag clouds & other member infographics

# Module containing raw sql queries used to generate raw text associated with users
# It might make more sense to implement these in each AR class ...


module FullText
  require 'lingua/stemmer'
  
  MinWordLength     = 4
  StopWordPatterns  = [Regexp.new('^https?://'), Regexp.new('^[0-9\W\_]+$'), Regexp.new('\S&\S')]
  
  FBActivityStreamQuery =<<SQL
SELECT SQL_NO_CACHE activity_stream_items.author AS author, activity_stream_items.message AS message, activity_stream_items.attachment_data AS metadata, activity_stream_items.comment_thread, GROUP_CONCAT(DISTINCT IFNULL(tags.name, '') SEPARATOR ' ') AS tags, GROUP_CONCAT(DISTINCT IFNULL(comments.title, '') SEPARATOR ' ') AS comment_title, GROUP_CONCAT(DISTINCT IFNULL(comments.comment, '') SEPARATOR ' ') AS comment
FROM activity_stream_items
LEFT OUTER JOIN taggings ON (activity_stream_items.id = taggings.taggable_id AND taggings.taggable_type = 'ActivityStreamItem')  LEFT OUTER JOIN tags ON (tags.id = taggings.tag_id) AND taggings.context = 'tags'   LEFT OUTER JOIN comments ON comments.commentable_id = activity_stream_items.id AND comments.commentable_type = 'ActivityStreamItem'
WHERE activity_stream_id = ? AND type = 'FacebookActivityStreamItem' AND deleted_at IS NULL
GROUP BY  activity_stream_items.id
SQL

  TwitterActivityStreamQuery=<<SQL
SELECT SQL_NO_CACHE activity_stream_items.author AS author, activity_stream_items.message AS message, GROUP_CONCAT(DISTINCT IFNULL(tags.name, '') SEPARATOR ' ') AS tags, GROUP_CONCAT(DISTINCT IFNULL(comments.title, '') SEPARATOR ' ') AS comment_title, GROUP_CONCAT(DISTINCT IFNULL(comments.comment, '') SEPARATOR ' ') AS comment
FROM activity_stream_items
LEFT OUTER JOIN taggings ON (activity_stream_items.id = taggings.taggable_id AND taggings.taggable_type = 'ActivityStreamItem')  LEFT OUTER JOIN tags ON (tags.id = taggings.tag_id) AND taggings.context = 'tags'   LEFT OUTER JOIN comments ON comments.commentable_id = activity_stream_items.id AND comments.commentable_type = 'ActivityStreamItem'
WHERE activity_stream_id = ? AND type = 'TwitterActivityStreamItem' AND deleted_at IS NULL
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
SELECT SQL_NO_CACHE contents.description AS description, GROUP_CONCAT(DISTINCT IFNULL(tags.name, '') SEPARATOR ' ') AS tags, GROUP_CONCAT(DISTINCT IFNULL(comments.title, '') SEPARATOR ' ') AS comment_title, GROUP_CONCAT(DISTINCT IFNULL(comments.comment, '') SEPARATOR ' ') AS comment
FROM contents
LEFT OUTER JOIN taggings ON (contents.id = taggings.taggable_id AND taggings.taggable_type = 'Content')  LEFT OUTER JOIN tags ON (tags.id = taggings.tag_id) AND taggings.context = 'tags'   LEFT OUTER JOIN comments ON comments.commentable_id = contents.id AND comments.commentable_type = 'Content'
WHERE contents.user_id = ? AND deleted_at IS NULL
GROUP BY contents.id
SQL

  class Frequency
    # Performs text analysis on some data store & returns word-count stats
    @@MinWordFrequency = 2
    
    def initialize
      @stemmer    = Lingua::Stemmer.new # TODO: Supports any language in constructor - get from user db?
      @stopwords  = stopwords
      @stems      = Hash.new
    end

    # Uses myisam_ftdump to collect collection of unique words from a fulltext index.
    # This is useful in 2 ways: 
    # => ftdump discards common words & short words, & we can probably use a stoplist
    # => ftdump only returns unique words in the result, making counting impossible NOOOO
    def analyze_ftdump(table)
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

    # Returns word frequency hash by analyzing input string
    def generate_hash(input)
      @freq = analyze_raw(input)
      # Reduce returning unnecessarily large hash be stripping away frequencies < min
      @freq.delete_if {|key, value| value < @@MinWordFrequency}
    end

    protected 

    def stopwords
      returning Hash.new do |h|
        File.open(File.join(RAILS_ROOT, "db/stopwords.csv")) do |f| 
          f.readline.split(',').map{|w| w.strip}.each { |w| h[w] = 1 }
        end
      end
    end

    def skip_word?(w)
      @stopwords[w] || (w.length < MinWordLength) || (w.last == ':') || StopWordPatterns.any?{|r| !r.match(w).nil?}
    end

    # Peforms brute-force fulltext parsing by tokenizing and creating dictionary 
    # with counts.  Tries to improve relevance using Stemming & stoplists
    def analyze_raw(txt)
      stem_freq = {}
      stem_lead = {}
      
      returning Hash.new(0) do |dict|
        txt.downcase.split(/[\s,;!\?]+/).each do |w|
          # Apply some custom rejection conditions
          next if skip_word?(w)
          # strip non-words chars
          w.gsub!(/["\(\)\.]+/, '')
          dict[w] += 1
        end

        # Peform stemming analysis
        dict.each do |w, freq|
          @stems[w] ||= @stemmer.stem(w)
          (stem_freq[@stems[w]] ||= {})[w] = freq
        end
        
        stem_freq.each_key do |stem|
          #puts "Analyzing stem #{stem}"
          total_freq = 0
          lead_freq = 0
          lead_word = ""
          
          #puts "stems => #{stem_freq[stem].inspect}"
          stem_freq[stem].each do |word, freq|
            total_freq += freq
            if freq > lead_freq
              lead_word = word
              lead_freq = freq
            end
          end
          #puts "lead word => #{lead_word} (#{total_freq})"
          stem_lead[lead_word] = total_freq
        end
        # Replace word frequency hash with leading stem frequency hash
        dict = stem_lead
      end
    end # def analyze_raw
  end # class Frequency
end # module FullText
  
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
  returning String.new do |str|
    while row = mysql_res.fetch_row
      str << row.compact.reject {|s| s.blank? || (s == "0")}.join(' ') rescue ''
    end
  end
end
  
# This method will create a temporary myisam table containing the passed text 
# with a fulltext index.  
# Attempted to perform text analysis using myisam_ftdump but it didn't 
# return the right kind of info...keeping for reference only.
def analyze_myisam_fulltext(u, text)
  tbl = "ft_#{u.id}"
  puts "Creating text dump table for user #{u.id} in #{tbl}"

  create_text_table(tbl, text)
  #Run myisam_ftdump on the table to get word stats
  stats = analyze_text(tbl)
  #Remove temp table
  remove_table(tbl)
  stats
end

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
  puts "Getting text for user #{user.id}"
  returning String.new do |txt|
    res = []
    # Facebook data contains way too much cruft in the serialized columns to parse from a raw sql query
    user.activity_stream.items.each do |as|
      res << as.to_rawtext
    end

    if (feed_ids = user.backup_sources.blog.map(&:id)).any?
      res << get_sql_result_str(@conn.execute(FullText::FeedQuery.gsub(/\?/, feed_ids.join(','))))
    end
    if (albums_ids = BackupPhotoAlbum.by_user(user.id).map(&:backup_source_id).uniq).any?
      res << get_sql_result_str(@conn.execute(FullText::PhotoAlbums.gsub(/\?/, albums_ids.join(','))))
    end
    res << get_sql_result_str(@conn.execute(FullText::Contents.gsub(/\?/, user.id.to_s)))
    
    txt << res.flatten.join(' ')
    puts "result: #{txt}"
  end
end

# Analysis related tasks
# Includes data mining, text processing, pattern finding tasks
namespace :analysis do
  desc "Calculates users' text data word frequencies"
  task :update_fulltext => :environment do
    include FullText
    # Global database connection
    @conn = ActiveRecord::Base.connection
    # Text frequency counter object
    @freq_analyzer = FullText::Frequency.new
    
    users = if ENV['USER_ID']
      [ User.find(ENV['USER_ID']) ]
    else
      User.active.all
    end
    # Per-user task
    users.each do |u|
      text = user_text_dump(u)

      unless text.blank?
        # stats = analyze_myisam_fulltext(text)
        stats = @freq_analyzer.generate_hash(text)
        puts stats.sort{|a,b| b[1] <=> a[1]}.inspect
        # Add word stats to user text table
        if rt = RawText.find_or_create_by_user_id(u.id)
          rt.update_attribute(:word_counts, stats)
        end
      end
    end
    
  end
end
  