require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivityStreamItem do
  include ActivityStreamProxySpecHelper
  
  it "should create a new instance given valid attributes" do
    lambda {
      create_activity_stream_item
    }.should change(ActivityStreamItem, :count).by(1)
  end
  
  before(:each) do
    @as = create_activity_stream
    Member.any_instance.stubs(:backup_sources).returns(stub(:facebook => [mock_model(BackupSource)]))
  end
  
  describe "facebook item" do
    before(:each) do
      @item = new_activity_stream_item :type => 'FacebookActivityStreamItem', :activity_stream => @as
      @proxy = create_stream_proxy_item
    end
    
    it "should have facebook type" do
      @item.should be_a FacebookActivityStreamItem
    end
    
    it "should create a new instance from a proxy object" do
      @item = FacebookActivityStreamItem.create_from_proxy! @as.id, @proxy
      @item.activity_type.should == 'status'
      @item.message.should == @proxy.message
      @item.attachment_data.should be_nil
    end
    
    it "should return nil for unset serialized columns" do
      @item.comment_thread.should be_nil
      @item.liked_by.should be_nil
    end

    describe "creating from proxy object" do
      it "should create the object scoped to the activity stream" do
        lambda {
          FacebookActivityStreamItem.create_from_proxy!(@as.id, @proxy)
        }.should change(@as.items.facebook, :count).by(1)
      end
      
      with_transactional_fixtures(:off) do
        describe "called from scope" do
          it "should call after_create callback" do
            FacebookActivityStreamItem.any_instance.expects(:process_attachment)
            FacebookActivityStreamItem.create_from_proxy! @as.id, @proxy
          end
        end
      end
    end
    
    describe "with sync_from_proxy" do
      it "should return nil object if unique" do
        @as.items.facebook.sync_from_proxy!(@proxy) {|s| nil}.should be_nil
      end

      it "should update record if found" do
        @proxy.comments = ['foo', 'foo']
        FacebookActivityStreamItem.create_from_proxy!(@as.id, @proxy)
        obj = @as.items.facebook.sync_from_proxy!(@proxy) do |scope|
          scope.find_by_guid(@proxy.id)
        end
        obj.reload.should_not be_nil
        obj.comment_thread.should == @proxy.comments
      end
      
      it "should scope find query to member's activity stream" do
        @item1 = create_activity_stream_item :type => 'FacebookActivityStreamItem'
        @item1_guid = @item1.guid
        
        @item2 = create_activity_stream_item :type => 'FacebookActivityStreamItem'
        lambda {
          @item2.member.activity_stream.items.facebook.sync_from_proxy! @proxy do |scope|
            scope.find_by_guid(@item1_guid.to_s)
          end
        }.should_not be_nil
      end
    end
    
    describe "JSON" do
      before(:each) do
        @json = @item.to_json
      end
      
      it "should support to_json" do
        ActiveSupport::JSON.decode(@json).should be_a Hash
      end
    end
    
    describe "with comments" do
      before(:each) do
        @item = FacebookActivityStreamItem.create_from_proxy!(@as.id, create_facebook_stream_proxy_item_with_comments)
      end
      
      it "should return comment thread as array of hashes" do
        @item.comment_thread.should_not be_empty
        @item.comment_thread.all?{|c| !c['text'].blank?}.should be_true
      end
    end
    
    describe "with 'likes'" do
      before(:each) do
        @item = FacebookActivityStreamItem.create_from_proxy!(@as.id, create_facebook_stream_proxy_item_with_likes)
      end
    
      it "should return likes as array of names" do
        @item.liked_by.should_not be_empty
        @item.liked_by.all?{|l| !l.blank?}.should be_true
      end
    end
    
    describe "with attachment data" do
      with_transactional_fixtures(:off) do
        describe "on create with photo" do
          before(:each) do
            @proxy_item = create_facebook_stream_proxy_item_with_attachment('photo')
            BackupPhotoAlbum.destroy_all
            BackupPhoto.destroy_all
          end
        
          it "proxy item should have an attachment attribute" do
            @proxy_item.attachment_data.should be_a Hash
          end
            
          it "should create the object scoped by user's facebook activity stream" do
            lambda {
              FacebookActivityStreamItem.create_from_proxy! @as.id, @proxy_item
            }.should change(@as.items.facebook, :count).by(1)
          end
      
          it "should create new BackupPhotoAlbum for the BackupPhoto" do
            lambda {
              @item = FacebookActivityStreamItem.create_from_proxy! @as.id, @proxy_item
              @item.should be_a FacebookActivityStreamItem
            }.should change(BackupPhotoAlbum, :count).by(1)
          end

          it "should create photo album for facebook friends if photo not user's" do
            @proxy_item.attachment_data['photo']['owner'] = '123'
            lambda {
              @item = FacebookActivityStreamItem.create_from_proxy! @as.id, @proxy_item
            }.should change(BackupPhotoAlbum.source_album_id_eq(BackupPhotoAlbum.facebookFriendsAlbumID), :size).by(1)
          end
          
          it "should create photo album for photo if photo is user's" do
            @proxy_item.attachment_data['photo']['owner'] = @as.member.facebook_id.to_s
            lambda {
              @item = FacebookActivityStreamItem.create_from_proxy! @as.id, @proxy_item
            }.should change(BackupPhotoAlbum.source_album_id_eq(@proxy_item.attachment_data['photo']['aid']), :size).by(1)
          end
          
          it "should not create duplicate photo albums on multiple saves" do
            @proxy_item.attachment_data['photo']['owner'] = @as.member.facebook_id.to_s
            lambda {
              2.times { FacebookActivityStreamItem.create_from_proxy! @as.id, @proxy_item }
            }.should change(BackupPhotoAlbum.source_album_id_eq(@proxy_item.attachment_data['photo']['aid']), :size).by(1)
          end
          
          it "should save the photo as a BackupPhoto" do
            lambda {
              @item = FacebookActivityStreamItem.create_from_proxy! @as.id, @proxy_item
              @item.send(:process_attachment)
            }.should change(BackupPhoto, :count).by(1)
          end
        end
      end
        
      describe "being a facebook photo" do
        before(:each) do
          @item = FacebookActivityStreamItem.create_from_proxy! @as.id, create_facebook_stream_proxy_item_with_attachment('photo')
        end
        
        it "should parse photo attachment data" do
          @item.activity_type.should == 'post'
          @item.attachment_type.should == 'photo'
        end

        it "should be a facebook photo" do
          @item.should be_facebook_photo
        end
        
        it "should be return the facebook BackupPhoto object" do
          BackupPhoto.expects(:find_by_source_photo_id).with(@item.attachment_data['photo']['pid']).returns(@bp = mock_model(BackupPhoto))
          @bp.expects(:photo)
          @item.facebook_photo
        end
        
        describe "url" do
          it "should search for a BackupPhoto object" do
            BackupPhoto.expects(:find_by_source_photo_id).with(@item.attachment_data['photo']['pid'])
            @item.url
          end
          
          it "should not return url if BackupPhoto url not valid" do
            BackupPhoto.stubs(:find_by_source_photo_id).returns(nil)
            @item.url.should be_nil
          end
          
          it "should return the source url if BackupPhoto url is valid" do
            BackupPhoto.stubs(:find_by_source_photo_id).returns(stub(:photo => stub(:url => 'http://s3.img')))
            @item.url.should match(/^http/)
          end
        end
      end

      describe "of type: generic" do
        with_transactional_fixtures(:off) do
          before(:each) do
            @item = FacebookActivityStreamItem.create_from_proxy! @as.id, @raw = create_facebook_stream_proxy_item_with_attachment('generic')
          end

          it "should store parse generic attachment data" do
            @item.activity_type.should == 'post'
            @item.attachment_type.should == 'generic'
          end

          it "should return the attachment data source url" do
            @item.url.should match(/^http/)
            @item.thumbnail_url.should be_blank
          end

          it "should not set the message attribute from the attachment on create if a message is present" do
            @raw['message'].should_not be_blank
            @item.message.should == @raw['message']
          end
          
          it "should set the message attribute from the attachment on create if a message is not present" do
            @raw = create_facebook_stream_proxy_item_with_attachment('generic')
            @raw['message'] = ''
            @item = FacebookActivityStreamItem.create_from_proxy! @as.id, @raw
            @item.message.should_not be_blank
          end
        end
      end
      
      describe "of type: friendfeed" do
        before(:each) do
          @item = FacebookActivityStreamItem.create_from_proxy! @as.id, create_facebook_stream_proxy_item_with_attachment('friendfeed')
        end
        
        it "should  parse generic attachment data" do
          @item.activity_type.should == 'post'
          @item.attachment_type.should == 'generic'
        end

        it "should set the message attribute from the attachment after create" do
          @item.message.should_not be_blank
        end
      end
      
      describe "of type: link" do
        before(:each) do
          @item = FacebookActivityStreamItem.create_from_proxy! @as.id, create_facebook_stream_proxy_item_with_attachment('link')
        end
        
        it "should store parse generic attachment data" do
          @item.activity_type.should == 'post'
          @item.attachment_type.should == 'link'
        end

        it "should return the attachment data source url" do
          @item.url.should match(/^http/)
          @item.thumbnail_url.should be_blank
        end
        
        describe "with description attributes" do
          before(:each) do
            @raw = create_facebook_stream_proxy_item_with_attachment('link_with_description')
            @item = FacebookActivityStreamItem.create_from_proxy! @as.id, @raw
          end
          
          it "should save descriptions as attachment attributes" do  
            %w( name description caption ).each do |attr|
              @item.parsed_attachment_data[attr].should == @raw.attachment[attr]
            end
          end
          
          it "should include description attributes when converting to JSON" do
            @json = @item.to_json
            %w( name description caption ).each do |attr|
              @json['message'].should match(/.*#{@raw[attr]}.*/)
            end
          end
        end
      end
    end
      
    it "should find with named scope" do
      @item.save
      ActivityStreamItem.facebook.find(@item.id).should == @item
    end
  end
  
  describe "twitter item" do
    before(:each) do
      @item = new_activity_stream_item :type => 'TwitterActivityStreamItem', :activity_stream => @as
      @proxy = create_stream_proxy_item
    end
    
    it "should have twitter type" do
      @item.should be_a TwitterActivityStreamItem
    end
    
    it "should create a new instance from a proxy object" do
      @item = TwitterActivityStreamItem.create_from_proxy! @as.id, @proxy
      @item.activity_type.should == 'status'
      @item.message.should == @proxy.message
    end
    
    it "should find with named scope" do
      @item.save
      ActivityStreamItem.twitter.find(@item.id).should == @item
    end
  end
end
