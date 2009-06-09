# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/common_settings_spec_helper')


describe Element, "on new" do  
  before(:each) do
    @story = create_story
    @element = new_element(:story => @story)
  end

  it "should not be valid without required parameters" do
    @element.should be_valid
    @element.title = nil
    @element.should_not be_valid
  end
  
  it "should respond to decorations method" do
    @element.should respond_to :decorations
  end
end

describe Element, "on create" do
  before(:each) do
    @story = create_story
    @object = @element = new_element(:story => @story, :tag_s => nil)
  end
  
  it_should_behave_like "an object with common settings on create"
end

describe Element, "with fixtures loaded" do
  fixtures :all
  
  before(:each) do
    @story = create_story
    @element = create_element(:story => @story)
  end
  
  it "should belong to a story" do
    @element.should respond_to :story
    @element.story.should be_an_instance_of Story
  end
  
  it "should not have contents if none added" do
    @element.contents.should be_empty
  end
  
  it "should have contents if added" do
    elements(:wedding_ceremony).contents.should include(contents(:wedding_ceremony_video))
    elements(:wedding_reception).contents.should include(contents(:wedding_reception_photo))
  end
  
  it "should return its contents from decorations method" do
    elements(:wedding_ceremony).decorations.should_not be_empty
  end
  
  it "decorations should contain all associated contents" do
    contents = elements(:wedding_ceremony).contents
    elements(:wedding_ceremony).decorations.each do |d|
      contents.should include d.content
    end
  end
end
