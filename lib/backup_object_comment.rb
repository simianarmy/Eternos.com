# $Id$

# BackupObjectComment module
#
# Mixin for AR Classes needing sync support for backup comments

module BackupObjectComment
  
  # Synchs existing photo comments with those in array arg
  def synch_backup_photo_comments(photo_comments)
    return if photo_comments.nil? || photo_comments.empty?
    
    #  synch with existing backup comments
    objects_to_add = if comments.nil? || comments.empty?
      photo_comments
    else
      # Get all existing comments' post times.  Synch will add any comment that does't
      # match existing post time.
      # May cause some comments to be skipped if many comments created at exactly the
      # same time!  Unlikely though...
      existing_comment_times = comments.map(&:created_at)
      photo_comments.select{|pc| not existing_comment_times.include?(pc.created_at)}
    end
    objects_to_add.each do |comm|
      add_backup_comment comm
    end
  end
  
  # Adds new backup proxy object comment, converting it to Comment object
  def add_backup_comment(comm)
    add_comment convert_backup_comment(comm)
  end
  
  # Converts backup comment object to a Comment object
  def convert_backup_comment(comm)
    Comment.new(comm.to_h.merge(:commentable => self))
  end
end