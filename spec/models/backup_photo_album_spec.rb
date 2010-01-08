# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupPhotoAlbum do
  include FacebookerSpecHelper
  include FacebookPhotoAlbumSpecHelper
  
  before(:each) do
    @source = create_backup_source
    @album = new_album
  end
  
  it "should return editable attributes array" do
    BackupPhotoAlbum.db_attributes.should be_a Array
    BackupPhotoAlbum.db_attributes.should == BackupPhotoAlbum.editableAttributes
  end
  
  it "should have a constant name for facebook friends' photos" do
    BackupPhotoAlbum.facebookFriendPhotos.should_not be_blank
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
          @backup.backup_photos.expects(:import).with(@photo)
          @backup.save_photos([@photo])
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
      end
    end
  end
end