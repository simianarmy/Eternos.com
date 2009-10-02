# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe ImageDownloadWorker do
  describe "on download_image" do
    def call_worker(id=1)
      ImageDownloadWorker.new.download_image(:id => id)
    end
    
    before(:each) do
      @item = create_backup_photo(:source_url => 'http://farm4.static.flickr.com/3320/3232136826_b3eed8916b.jpg?v=0')
    end
    
    it "should download an image from a network source" do
      call_worker(@item.id)
      @item.reload.photo.should be_a Photo
    end
  end
end