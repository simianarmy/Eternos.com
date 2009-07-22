require File.dirname(__FILE__) + '/../spec_helper'

describe BackupPhotoDownloader do
  describe "on download failure" do
    before(:each) do
      @photo = create_backup_photo(:source_url => 'nowhere')
    end
    
    it "should save download error" do
      BackupPhoto.any_instance.expects(:download_error!)
      BackupPhotoDownloader.run(0)
    end
  end
  
  describe "on download success" do
    before(:each) do
      @photo = create_backup_photo(:source_url => 'http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs101.snc1/4550_1163133110924_1005737378_30498231_7155402_n.jpg')
    end
    
    it "should create a photo object" do
      lambda {
        BackupPhotoDownloader.run(0)
      }.should change(Content, :count).by(1)
    end
    
    it "new photo object should be associated to backup photo" do
      @photo.photo.should be_nil
      BackupPhotoDownloader.run(0)
      @photo.reload.photo.should_not be_nil
    end
  end
end