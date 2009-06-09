require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AlbumsController do

  #Delete these examples and add some real ones
  it "should use AlbumsController" do
    controller.should be_an_instance_of(AlbumsController)
  end


  describe "GET 'album'" do
    it "should be successful" do
      get 'album'
      response.should be_success
    end
  end
end
