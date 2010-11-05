# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../facebook_spec_helper')

describe BackupPhotoAlbum do
  include FacebookSpecHelper
  include FacebookerSpecHelper
  include FacebookProxyObjectSpecHelper
  
  
  before(:each) do
    @source = create_backup_source
    @album = new_album
  end
  
  it "should return editable attributes array" do
    BackupPhotoAlbum.db_attributes.should be_a Array
    BackupPhotoAlbum.db_attributes.should == BackupPhotoAlbum.editableAttributes
  end
  
  it "should have a constants for facebook friends' photo albums" do
    BackupPhotoAlbum.facebookFriendsAlbumName.should_not be_blank
    BackupPhotoAlbum.facebookFriendsAlbumID.should_not be_blank
  end
  
  it "should create object on import" do
    lambda {
      BackupPhotoAlbum.import @source, @album
    }.should change(BackupPhotoAlbum, :count).by(1)
  end
  
  it "should be saved with attributes from album" do
    @backup = BackupPhotoAlbum.import @source, @album
    @backup.modified.should == '1244850471'
  end
  
  describe "initialized" do
    before(:each) do
      @backup = BackupPhotoAlbum.import @source, @album
    end
    
    it "should have no photos" do
      @backup.backup_photos.should be_empty
    end
    
    describe "on modified?" do
      it "should return false if album has not changed" do
        @backup.modified?(@album).should be_false
      end
      
      it "should return true if album modified" do
        @album.modified = "#{@album.modified.to_i + 100}"
        @backup.modified?(@album).should be_true
      end
    end
    
    describe "on update" do
      it "should update all changeable fields" do
        og_aid = @backup.source_album_id
        @album.name = 'new name'
        @album.size = 3
        @album.aid = 1000
        @backup.save_album @album
        @backup.reload.name.should == 'new name'
        @backup.size.should == 3
        @backup.source_album_id.should == og_aid
      end
    end
    
    describe "on save photos" do
      before(:each) do
        @photo = new_photo
        BackupPhoto.any_instance.stubs(:source_url).returns(@photo_url = File.dirname(__FILE__) + '/../../public/images/board.gif')
      end
      
      describe "association" do
        it "should save collection of photo objects" do
          lambda {
            @backup.save_photos([@photo])
          }.should change(@backup.backup_photos, :count).by(1)
        end
      
        it "should save new photos" do
          lambda {
            @backup.save_photos([@photo])
          }.should change(BackupPhoto, :count).by(1)
        end
      
        it "should not add the same photo object to association" do
          lambda {
            2.times { @backup.save_photos([@photo]) }
          }.should change(BackupPhoto, :count).by(1)
        end
      
        it "should delete photos that are not in the album anymore" do
          @backup.save_photos([@photo])
          orig = @backup.backup_photos.first
          @backup.save_photos([@newone = new_photo])
          @backup.reload.backup_photos.size.should == 1
          @backup.backup_photos.first.should_not == orig
        end
        
        it "new photo object should be saved in association with valid attributes" do
          @backup.save_photos([@photo])
          @backup.backup_photos.should have(1).thing
          photo = @backup.backup_photos.first
          photo.caption.should == @photo.caption
          photo.source_url.should == @photo_url
          photo.tags.should == nil
        end
        
        it "should save photo with tags array" do
          @photo.tags = @tags = %w[foo, foo shoo]
          @backup.save_photos([@photo])
          @backup.backup_photos.first.tags.should == @tags
        end
        
        describe "with photo comments" do
          describe "from facebook" do
            def photo_with_comments
              returning(new_photo) do |p|
                p.comments = [fb_comment]
              end
            end
          
            it "should save comments in backup photo object" do
              p = photo_with_comments
              @backup.save_photos [p]
              @backup.backup_photos.first.comments.should have(1).thing
            end
            
            it "should save commenter data in backup photo comment's serialized attribute" do
              p = photo_with_comments
              @backup.save_photos [p]
              @backup.backup_photos.first.comments.first.commenter_data['username'].should == p.comments.first.user_data['username']
            end
          end
        end
      end
      
      describe "with photos" do
        before(:each) do
          fb_photo = new_facebooker_photo
          fb_photo.created = Time.now - 100.years
          @photo = new_photo(fb_photo)
          @backup.save_photos([new_photo, @photo])
        end
        
        it "start_date should return oldest photo's date" do
          @backup.start_date.should == @photo.added_at
        end
      end
    end
  end
end