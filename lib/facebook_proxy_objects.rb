# $Id$

require 'lib/backup_content_proxy'
require 'facebooker'

# Facebook proxy objects for data from backup daemons

module FacebookProxyObjects
  
  class FacebookPhotoAlbum < BackupPhotoAlbumProxy
    attr_reader :album

    def initialize(a)
      raise InvalidAlbumClassError unless a.class == Facebooker::Album
      @album = a
    end

    def id
      @album.aid
    end

    def cover_id
      @album.cover_pid
    end
  end

  class FacebookPhoto < BackupPhotoProxy
    attr_reader :photo, :comments
    attr_accessor :tags

    def initialize(p)
      raise InvalidPhotoClassError unless p.class == Facebooker::Photo
      @photo = p
    end

    def id
      @photo.pid
    end

    def source_url
      @photo.src_big
    end

    def added_at
      Time.at(@photo.created.to_i) unless @photo.created.blank?
    end

    def modified_at
      nil # not supported by facebook
    end

    # Converts facebook comments array to standard format for Comment object
    def comments=(fb_comments)
      return if fb_comments.nil?
      @comments = fb_comments.map do |comm|
        FacebookObjectComment.new comm
      end
    end
  end

  # Backup Comment format using BackupObjectCommentProxy object
  class FacebookObjectComment < BackupObjectCommentProxy
    def initialize(comm)
      raise InvalidCommentClassError unless comm.respond_to?(:text)
      @comment = comm
    end
  
    def title
    end
  
    def created_at
      Time.at(@comment.time.to_i) rescue nil
    end
  
    def commenter_data
      @comment.user_data
    end
  
    def comment
      @comment.text
    end
  
    def external_id
      @comment.xid
    end
  end
end