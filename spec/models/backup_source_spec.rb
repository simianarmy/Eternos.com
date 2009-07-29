# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupSource do
  it "should return photo album by album id" do
    create_backup_photo_album(:source_album_id => '100')
    BackupSource.photo_album('100').should_not be_nil
  end
  
  describe "on new" do
    before(:each) do
      @bs = new_backup_source
    end
    
    it "should be valid with required attributes" do
      @bs.should be_valid
    end
    
    it "should create an object" do
      lambda {
        @bs.save
      }.should change(BackupSource, :count).by(1)
    end
    
    it "should allow multiple backup sites per user" do
      lambda {
        @bs.save
        create_backup_source(:member => @bs.member, :backup_site => @bs.backup_site)
      }.should change(BackupSource, :count).by(2)
    end
  end
  
  describe "created" do
    before(:each) do
      @bs = create_backup_source
    end
    
    describe "with photo albums" do
      before(:each) do
      end
      
      it "should have multiple photo albums" do
        create_backup_photo_album(:backup_source => @bs)
        @bs.backup_photo_albums.size.should == 1
      end
      
      it "should return photo album by album id" do
        @bs.photo_album(100).should be_nil
        create_backup_photo_album(:backup_source => @bs, :source_album_id => '100')
        @bs.photo_album('100').should_not be_nil
      end
    end
  end
  
end