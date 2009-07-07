# $Id$

describe BackupSourcesController do
  describe "GET add_feed_url" do
    it "should be successful" do
      get 'album'
      response.should be_success
    end
  end
end