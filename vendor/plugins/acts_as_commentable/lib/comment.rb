class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  
  # NOTE: install the acts_as_votable plugin if you 
  # want user to vote on the quality of comments.
  #acts_as_voteable
  
  # NOTE: Comments belong to a user
  belongs_to :author, :class_name => 'User', :foreign_key => 'user_id'
  
  # To store any extra info on the commenter, for Facebook & others
  serialize :commenter_data
  
  #validates_existence_of :author, :message => "You must be logged in to comment"
  validates_presence_of :commentable, :message => "Nothing to comment on"
  validates_presence_of :comment, :message => "Please enter a comment"
  
  acts_as_archivable
  
  include TimelineEvents
	include CommonDateScopes
  include CommonDurationScopes
  
  # Editable attributes for BackupContentProxy objects
  @@editableAttributes = [:created_at, :title, :comment, :commenter_data, :external_id]
  cattr_reader :editableAttributes
  
  def self.db_attributes
    editableAttributes
  end
  
  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  def self.find_comments_by_user(user)
    find(:all,
      :conditions => ["user_id = ?", user.id],
      :order => "created_at DESC"
    )
  end
  
  # Helper class method to look up all comments for 
  # commentable class name and commentable id.
  def self.find_comments_for_commentable(commentable_str, commentable_id)
    find(:all,
      :conditions => ["commentable_type = ? and commentable_id = ?", commentable_str, commentable_id],
      :order => "created_at DESC"
    )
  end

  # Helper class method to look up a commentable object
  # given the commentable class name and id 
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
  
  # Using polymorphic associations in combination with single table inheritance (STI) is a little tricky. In order 
  # for the associations to work as expected, ensure that you store the base model for the STI models in the  
  # type column of the polymorphic association. 
  def commentable_type=(sType) 
    super(sType.to_s.classify.constantize.base_class.to_s) 
  end

  # Need this to get past AssociationTypeMismatch errors when assigning sti child 
  # classes of User
  def author=(object)
    write_attribute(:user_id, object.id) if object
  end
end