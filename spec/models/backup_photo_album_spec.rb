# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module FacebookPhotoAlbumSpecHelper
  def create_album
    FacebookPhotoAlbum.new(Facebooker::Album.new(:aid => "100", 
      :size=> 2, :link => 'link_url', :cover_pid => '10', :name => 'test album',
      :modified => '1244850471', :aid => '100', :populated => true, :location => 'nowwhere'))
  end
end

describe BackupPhotoAlbum do
  include FacebookPhotoAlbumSpecHelper
  
  before(:each) do
    @source = create_backup_source
    @album = create_album
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
        @backup.modify @album
        @backup.reload.name.should == 'new name'
        @backup.size.should == 3
        @backup.source_album_id.should == og_aid
      end
    end
  end
end