# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WysiwygPreview do
  def wysiwyg_source_with_images
    <<-WIZ
<p><img src="..." id="artifact_photo_1" /></p>
    WIZ
  end
  
  describe "previewing with images" do
    before(:each) do
      Photo.expects(:find).with(1).returns(@photo = create_content(:type => :photo))
      @wys = WysiwygPreview.new(wysiwyg_source_with_images)
    end
    
    it "filter method should add lightview links to all photo thumbnails" do
      @wys.filter.should match(/lightview/)
    end
  end
end