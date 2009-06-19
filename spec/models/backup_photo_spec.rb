# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../../lib/facebook_photo_album'

describe BackupPhoto do
  describe "Facebook" do
     include FacebookPhotoAlbumSpecHelper
     include FacebookerSpecHelper
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
      it "should download image from source to temp file" do
        Photo.expects(:create)
        @photo.save
      end
    end
    
    describe "downloaded from source" do
      # Stub rio method
      def rio(file); end
      
      before(:each) do
      end
    
      it "file should be added as a Photo object to member media collection" do
        lambda {
          @photo.save
        }.should change(Photo, :count).by(1) && change(PhotoThumbnail, :count).by(1)
        
      end
      
      it "should association to Photo" do
        @photo.save
        @photo.reload.photo.should be_an_instance_of Photo
        @photo.photo.parent_id.should == @photo.id
      end
    end
  end   
end
