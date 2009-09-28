# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FacebookPhotoAlbum do
  describe "on new" do
    it "should raise exception without a Facebooker::Album object" do
      lambda { FacebookPhotoAlbum.new }.should raise_error ArgumentError
      lambda { FacebookPhotoAlbum.new(1) }.should raise_error FacebookPhotoAlbum::InvalidAlbumClassError
    end
  end
  
  describe "initialized" do
    before(:each) do
      @fb_album = Facebooker::Album.new(:aid => 111)
      @album = FacebookPhotoAlbum.new(@fb_album)
    end
    
    it "should return album id" do
      @album.id.should == @fb_album.aid
    end
    
    it "should delegate missing methods to facebooker::album object" do  
      @fb_album.expects(:modified)
      @album.modified
      @fb_album.expects(:modified=).with(100)
      @album.modified = 100
    end
    
    it "should return attribute hash on to_h" do
      @album.to_h.should be_a Hash
      @album.to_h.should_not be_empty
    end
  end
end

    describe FacebookPhoto do
      describe "on new" do
        it "should raise exception without a Facebooker::Photo object" do
          lambda { FacebookPhoto.new }.should raise_error ArgumentError
          lambda { FacebookPhoto.new(1) }.should raise_error FacebookPhoto::InvalidPhotoClassError
        end
      end

      describe "initialized" do
        before(:each) do
          @photo = FacebookPhoto.new(Facebooker::Photo.new(:pid => "1234", :src_big => 'foo.jpg'))
        end

        it "should return custom attributes" do
          @photo.id.should == "1234"
          @photo.source_url.should == 'foo.jpg'
        end

        it "should return attribute hash on to_h" do
          @photo.to_h.should be_a Hash
        end
      end
    end