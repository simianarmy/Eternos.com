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
    RAILS_DEFAULT_LOGGER.debug "searching with attributes: #{sphinx_attributes}"
    @results = ThinkingSphinx.search terms, :with => sphinx_attributes
  end

  def reset
    @results.clear
  end
  
  protected
  
  def sphinx_attributes
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