# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/av_attachment_spec_helper')

describe Photo do
  include ContentSpecHelper
  
  describe "on rebuild thumbnails" do
    before(:each) do
      @photo = create_content(:type => :photo)
    end
    
    with_transactional_fixtures :off do
      it "should build new thumbnail files & db records" do
        thumbs = @photo.thumbnails
        @photo.rebuild_thumbnails
        @photo.reload.thumbnails.should_not == thumbs
      end
    end
  end
end