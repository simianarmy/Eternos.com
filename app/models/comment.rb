class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  
  # NOTE: install the acts_as_votable plugin if you 
  # want user to vote on the quality of comments.
  #acts_as_voteable
  
  # Comments written by a user, but not always (if created off-site)
  belongs_to :author, :class_name => 'User', :foreign_key => 'user_id'
  
  # To store any extra info on the commenter, for Facebook & others
  serialize :commenter_data
  
  validates_presence_of :commentable, :message => "Nothing to comment on"
  validates_presence_of :comment, :message => "Please enter a comment"
  
  # Timeline & search stuff
  acts_as_archivable
  
  include TimelineEvents
	include CommonDateScopes
  include CommonDurationScopes
  
  # For serializing to json
  ETComment = Struct.new("ETComment", :comment, :title, :created_at, :commenter_data)
  
  serialize_with_options do
    methods :earlier_comments
    except :commentable_id, :commentable_type, :user_id, :external_id
  end
  
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
  
  # Returns commment thread of this comment in any order.  Up to the caller
  # to sort the results
  # shortcut for acts_as_commentable's find_comments_for class method
  def thread
    commentable.try(:comments)
  end
  
  # Returns all comments in comment thread before this one
  def thread_before
    return unless commentable
    commentable.comments.created_at_lt(created_at)
  end
  
  # Returns all comments in comment thread after this one
  def thread_after
    return unless commentable
    commentable.comments.created_at_gt(created_at)
  end
  
  protected
  
  # Helper for serializing to JSON so that thread_before is not called 
  # recursively by serialize_with_options.
  # It returns the results of thread_before as structs instead of Comment objects.
  # These will automatically be serialized as-is
  def earlier_comments
    
    if comms = thread_before
      comms.map do |c| 
        ETComment.new(c.comment, c.title, c.created_at, c.commenter_data)
      end
    end
  end
  
end