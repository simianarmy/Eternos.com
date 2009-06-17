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
  end
end
    