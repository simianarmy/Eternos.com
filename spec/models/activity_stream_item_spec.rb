require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivityStreamItem do
  include ActivityStreamProxySpecHelper
  
  it "should create a new instance given valid attributes" do
    lambda {
      create_activity_stream_item
    }.should change(ActivityStreamItem, :count).by(1)
  end
  
  describe "facebook item" do
    before(:each) do
      @item = new_activity_stream_item :type => 'FacebookActivityStreamItem'
      @proxy = create_stream_proxy_item
    end
    
    it "should have facebook type" do
      @item.should be_a FacebookActivityStreamItem
    end
    
    it "should create a new instance from a proxy object" do
      @item = FacebookActivityStreamItem.create_from_proxy @proxy
      @item.activity_type.should == 'status'
      @item.message.should == @proxy.message
      @item.attachment_data.should be_nil
    end
    
    describe "JSON" do
      before(:each) do
        @json = @item.to_json
      end
      
      it "should support to_json" do
        ActiveSupport::JSON.decode(@json).should be_a Hash
      end
      
    end
    
    describe "with attachment data" do
      before(:each) do
        @as = create_activity_stream
        FacebookActivityStreamItem.any_instance.stubs(:member).returns(@member = mock_model(Member))
        @member.stub_chain(:backup_sources, :facebook).returns([mock_model(BackupSource)])
      end
      
      describe "photo on create" do
        before(:each) do
          @item = FacebookActivityStreamItem.create_from_proxy(create_facebook_stream_proxy_item_with_attachment('photo'))
        end
        
        with_transactional_fixtures(:off) do
          it "should be execute after_commit_on_update without errors" do
            lambda {
              @as.items << @item
            }.should_not raise_error
          end

          it "should create new BackupPhotoAlbum for the BackupPhoto" do
            BackupPhotoAlbum.destroy_all
            BackupPhoto.destroy_all
            lambda {
              @as.items << @item
              }.should change(BackupPhotoAlbum, :count).by(1)
          end

          it "should save the photo as a BackupPhoto" do
            BackupPhotoAlbum.destroy_all
            BackupPhoto.destroy_all
            lambda {
              @as.items << @item
            }.should change(BackupPhoto, :count).by(1)
          end
        end
      end
        
      describe "being a facebook photo" do
        before(:each) do
          @item = FacebookActivityStreamItem.create_from_proxy create_facebook_stream_proxy_item_with_attachment('photo')
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
            @item = FacebookActivityStreamItem.create_from_proxy create_facebook_stream_proxy_item_with_attachment('generic')
          end

          it "should store parse generic attachment data" do
            @item.activity_type.should == 'post'
            @item.attachment_type.should == 'generic'
          end

          it "should return the attachment data source url" do
            @item.url.should match(/^http/)
            @item.thumbnail_url.should be_blank
          end

          it "should set the message attribute from the attachment after update" do
            @item.message.split("\n").size.should == 3
          end
        end
      end
      
      describe "of type: friendfeed" do
        before(:each) do
          @item = FacebookActivityStreamItem.create_from_proxy create_facebook_stream_proxy_item_with_attachment('friendfeed')
        end
        
        it "should store parse generic attachment data" do
          @item.activity_type.should == 'post'
          @item.attachment_type.should == 'generic'
        end

        it "should set the message attribute from the attachment after create" do
          @item.message.should_not be_blank
        end
      end
      
      describe "of type: link" do
        before(:each) do
          @item = FacebookActivityStreamItem.create_from_proxy create_facebook_stream_proxy_item_with_attachment('link')
        end
        
        it "should store parse generic attachment data" do
          @item.activity_type.should == 'post'
          @item.attachment_type.should == 'link'
        end

        it "should return the attachment data source url" do
          @item.url.should match(/^http/)
          @item.thumbnail_url.should be_blank
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
      @item = new_activity_stream_item :type => 'TwitterActivityStreamItem'
      @proxy = create_stream_proxy_item
    end
    
    it "should have twitter type" do
      @item.should be_a TwitterActivityStreamItem
    end
    
    it "should create a new instance from a proxy object" do
      @item = TwitterActivityStreamItem.create_from_proxy @proxy
      @item.activity_type.should == 'status'
      @item.message.should == @proxy.message
    end
    
    it "should find with named scope" do
      @item.save
      ActivityStreamItem.twitter.find(@item.id).should == @item
    end
  end
end
