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
        File.cp File.dirname(__FILE__) + '/../../public/images/bigtest.jpg', 
          @tempfile = Test::Unit::TestCase.fixture_path + 'crap.jpg'
        puts "Tempfile => #{@tempfile}"
        @photo.stubs(:source_url).returns(@tempfile)
        # RIO::Rio.expects(:rio).at_least(2).returns(@rio = mock('Rio'))
        #         @rio.stubs(:<).returns(@rio)
        #         @rio.stubs(:bytes).returns(100)
        #         @rio.expects(:remove)
        @photo.save
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
    end
  end   
end
