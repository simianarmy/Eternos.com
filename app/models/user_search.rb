# $Id$

# Search helper class for user data searching

class UserSearch
  attr_reader :results
  attr_accessor :user
   
  SearchObjects = {
    'ActivityStreamItem'  => :activity_stream_id,
    'Address'             => :user_id,
    'BackupEmail'         => :backup_source_id,
    'BackupPhotoAlbum'    => :backup_source_id,
    'Content'             => :user_id,
    'FacebookMessage'     => :backup_source_id,
    'Family'              => :profile_id,
    'Feed'                => :backup_source_id,
    'FeedEntry'           => :feed_id,
    'Job'                 => :profile_id,
    'Medical'             => :profile_id,
    'MedicalCondition'    => :profile_id,
    'School'              => :profile_id
  }
  
  def initialize(user)
    @user = user
    @results = []
  end
  
  # Performs text search using passed search terms & options on all 
  # available text content
  # Search backend: Sphinx
  # Rails search interface: thinking_sphinx
  
  # => options: alternative attributes search hash
  def execute(terms=nil, options=nil)
    reset
    if terms.nil? || terms.blank?
      if options
        Rails.logger.debug "searching for attributes #{options.inspect}"
        @results = ThinkingSphinx.search nil, :with => options
      end
    else
      Rails.logger.debug "searching for #{terms}"
      SearchObjects.each do |obj, attribute|
        Rails.logger.debug "Search #{obj} by attribute #{attribute}"
        @results += obj.constantize.search terms, :with => gen_attribute(attribute)
      end
    end
    @results
  end

  def reset
    @results.clear
  end
  
  protected
  
  def gen_attribute(attribute)
    case attribute
    when :user_id
      {:user_id => @user.id}
    when :backup_source_id
      @bs ||= @user.backup_sources
      {:backup_source_id => collect_sphinx_attributes(@bs)}
    when :profile_id
      {:profile_id => @user.profile.id}
    when :activity_stream_id
      {:activity_stream_id => @user.activity_stream.id}
    when :feed_id
      {:feed_id => collect_sphinx_attributes(@user.backup_sources.blog.map{|b| b.feed})}
    end
  end
  
  def sphinx_attributes
    # DEPRECATED: TURNS OUT YOU CAN'T SELECT WITH ORs ON ATTRIBUTES IN SPHINX!
    @attributes ||= {
      :user_id => @user.id,
      :profile_id => @user.profile.id,
      :activity_stream_id => @user.activity_stream.id,
      :backup_source_id => collect_sphinx_attributes(@user.backup_sources),
      :feed_id => collect_sphinx_attributes(@user.backup_sources.blog.map{|b| b.feed})
    }
  end
  
  def collect_sphinx_attributes(collection)
    collection.any? ? collection.collect(&:id) : [nil]
  end
end