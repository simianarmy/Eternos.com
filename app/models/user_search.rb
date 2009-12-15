# $Id$

# Search helper class for user data searching

class UserSearch
  attr_reader :results
  attr_accessor :user
  
  def initialize(user)
    @user = user
    @results = []
  end
  
  # Performs text search using passed search terms & options on all 
  # available text content
  # Search backend: Sphinx
  # Rails search interface: thinking_sphinx
  def execute(terms, options={})
    reset
    
    # Using sphinx_scope to scope results to @user
    # Media search
    @results += Content.by_user(@user.id).search(terms)

    # Profile search
    # a member profile has many associations - find them dynamically
    # thinking_sphinx requires a class array
    profile_association_classes = Profile.reflect_on_all_associations(:has_many).map { |reflection|
      reflection.options[:class_name] ? reflection.options[:class_name] : reflection.name
      }.map(&:to_s).map(&:classify).map(&:constantize)
      debugger
    @results += ThinkingSphinx.search(terms, :classes => profile_association_classes, 
      :with => {:profile_id => @user.profile.id})

    # Activity stream search
    @results += ActivityStreamItem.search(terms, :with => {:activity_stream_id => @user.activity_stream.id})

    # Feed search
    feed_ids = @user.backup_sources.blog.map(&:id)
    @results += FeedEntry.search(terms, :with => {:feed_id => feed_ids})
    @results += Feed.search(terms, :with => {:backup_source_id => feed_ids})

    # Email search
    @results += BackupEmail.search(terms, :with => {:backup_source_id => @user.backup_sources.gmail.map(&:id)})
  end

  def reset
    @results.clear
  end
end