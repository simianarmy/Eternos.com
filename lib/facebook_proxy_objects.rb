# $Id$

require File.join(File.dirname(__FILE__), 'backup_content_proxy')
require 'facebooker'

# Facebook proxy objects for data from backup daemons

module FacebookProxyObjects
  module Rest
    # Proxy for Facebooker::Album object
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

    # Proxy for Facebooker::Photo object
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

    # Proxy for Facebooker::Page object
    class FacebookerPageProxy
      include BackupContentProxy
      IGNORE_PROXY_ATTRIBUTES = %w( session )

      # We need to return a hashie object from the facebooker object data
      def initialize(fb_page)
        res = (fb_page.methods.grep(/\w=$/).map(&:chop) - IGNORE_PROXY_ATTRIBUTES).inject({}) do |res, attr|
          res[attr] = fb_page.send(attr) if fb_page.respond_to?(attr)
          res
        end
        @page = Hashie::Mash.new(res)
      end

      def obj
        @page
      end
    end

    # Proxy for Facebooker::MessageThread object
    class FacebookMessageThread
      include BackupContentProxy
      class InvalidMessageThreadClassError < StandardError; end

      def initialize(obj)
        raise InvalidMessageThreadClassError unless obj.class == Facebooker::MessageThread
        @thread = obj
      end

      def obj
        @thread
      end

      def id
        @thread.id
      end

      def updated_at
        Time.at(@thread.updated_time.to_i)
      end

      def fb_object_id
        @thread.object_id
      end
    end
  end

  module OpenGraph
    # Backup Comment format using BackupObjectCommentProxy object
    class ObjectComment < BackupObjectCommentProxy
      def initialize(comm)
        raise InvalidCommentClassError unless comm.respond_to?(:message)
        @comment = comm
      end

      def title
      end

      def created_at
        @comment.created_time
      end

      def commenter_data
        @comment.from.name
      end

      def comment
        @comment.message
      end

      def external_id
        @comment.id
      end
    end
    
    # Proxy for OpenGraph hash object
    class PhotoAlbum < BackupPhotoAlbumProxy
      def initialize(a)
        @album = a
      end

      def id
        @album.id
      end

      def modified
        @album.updated_time
      end

      def size
        @album.count
      end

      def cover_id
      end
    end
    
    class Photo < BackupPhotoProxy
      def initialize(p)
        @photo = Hashie::Mash.new(p)
      end
      
      def id
        @photo.id
      end
      
      def title
        @photo.name
      end
      alias_attribute :caption, :title

      def source_url
        @photo.source
      end

      def added_at
        @photo.created_time
      end

      def modified_at
        @photo.updated_time
      end
      
      # Returns comments converted to ObjectComment objects
      def comments
        # Hashie array accessed with data attribute
        if @photo.comments
          @comments ||= @photo.comments.data.map {|c| ObjectComment.new(c) }
        end
      end
    end
  end
end