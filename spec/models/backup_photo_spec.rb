# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../facebook_spec_helper')

describe BackupPhoto do
  include FacebookProxyObjectSpecHelper
  include FacebookerSpecHelper
  include FacebookSpecHelper
   
  # This method is required because Fixjour can't handle creating objects 
  # with associations unless the database structure is setup with nil columns allowed/not allowed. 
  # Either way, that is stupid.
  def create_backup_photo_for_real
    returning(new_backup_photo) do |p|
      p.backup_photo_album = create_backup_photo_album(:backup_source => create_backup_source)
      p.save
      # Setup source file and stub url
      File.cp File.dirname(__FILE__) + '/../../public/images/bigtest.jpg', 
        @tempfile = ActiveSupport::TestCase.fixture_path + 'crap.jpg'
      p.stubs(:source_url).returns(@tempfile)
    end
  end

  describe "on create" do
    before(:each) do 
      @photo = new_backup_photo(:source_url => 'http://farm4.static.flickr.com/3320/3232136826_b3eed8916b.jpg?v=0')
    end
    
    it "should create object" do
      @photo.stubs(:download)
      lambda {
        @photo.save
      }.should change(BackupPhoto, :count).by(1)
    end
    
    describe "on download" do
      before(:each) do
        @photo.save
      end
      
      it "should call create new Photo object from source file" do
        Photo.expects(:create!)
        @photo.download
      end
    end
    
    describe "downloading from source" do
      # Stub rio method
      def rio(file)
      end
        
      before(:each) do
        @photo = create_backup_photo_for_real
        
        # RIO::Rio.expects(:rio).at_least(2).returns(@rio = mock('Rio'))
        #         @rio.stubs(:<).returns(@rio)
        #         @rio.stubs(:bytes).returns(100)
        #         @rio.expects(:remove)
      end

      it "photo should always belong to a backup photo album" do
        @photo.backup_photo_album.should_not be_nil
      end
      
      it "file should be added as a Photo object to member media collection" do
        lambda {
          @photo.starting_download!
        }.should change(Photo, :count).by(1)
      end
      
      it "should save association to Photo object" do
        @photo.starting_download!
        @photo.reload.photo.should be_an_instance_of Photo
      end
      
      it "should create thumbnail of photo object" do
        @photo.starting_download!
        @photo.photo.thumbnails.should have(1).thing
      end
      
      it "should assign tags to photo object" do
        @photo.tags = 'foo, fee'
        @photo.starting_download!
        @photo.reload.photo.tags.should have(2).things
      end
      
      it "should assign added_at attribute to photo object" do
        @photo.added_at = Time.now
        @photo.starting_download!
        @photo.reload.photo.taken_at.should == @photo.added_at
      end
      
      it "should assign photo's backup photo album to photo object collection attribute" do
        @photo.starting_download!
        @photo.reload.photo.collection.should == @photo.backup_photo_album
      end
      
      describe "photo with comments" do
        before(:each) do 
          @photo.add_comment(create_comment(:commentable => @photo, :commenter_data => {:foo => 1}))
        end
        
        it "should assign comments to photo object" do
          @photo.starting_download!
          comm = @photo.reload.photo.comments.first
          comm.commentable.should == @photo.photo
          comm.commenter_data['foo'].should == 1
        end
      end
    end
  end
  
  describe "on update" do
    def create_proxy_fb_comment
      new_proxy_fb_comment(fb_comment)
    end
    
    before(:each) do
      @photo = create_backup_photo_for_real
      @photo.starting_download!
      @photo.reload
    end
    
    describe "synching backup comments" do
      it "should only synch backup comments to photo object's list" do
        comments = [create_proxy_fb_comment]
        @photo.photo.expects(:synch_backup_comments).with(comments)
        @photo.expects(:synch_backup_comments).never
        @photo.synch_comments(comments)
      end
    end
  end   
end
