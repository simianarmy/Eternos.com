# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/common_settings_spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/av_attachment_spec_helper')

describe Story, "on new" do
  before(:each) do
    @object = @story = new_story
  end
  
  it "should be invalid without required fields" do
    @story.should be_valid
    @story.title = nil
    @story.should_not be_valid
  end
  
  it "should be created" do
    lambda{ 
      @story.save
      @story.should_not be_new_record
    }.should change(Story,:count).by(1)
  end
  
  it_should_behave_like "a new object with categories"
  it_should_behave_like "a new object with av attachment"
  
  describe "" do
    before(:each) do
      @object = @story = create_story
    end
  
    describe Story, "on update" do  
      it "should be invalid without required attributes" do
        @story.should be_valid
        @story.title = ''
        @story.should_not be_valid
        @story.should have_at_least(1).error_on(:title)
      end
    
      it_should_behave_like "an object with common settings on update"
      it_should_behave_like "an object with av attachment"
    end

    describe Story, "with elements" do  
      before(:each) do
        create_element(:story=>@story)
      end
  
      it "should respond to elements" do
        @story.should respond_to :elements
      end
  
      it "should belong to the story" do
        @story.elements.should_not be_empty
        @story.elements.each { |e| e.story.should be_eql(@story) }
      end
    end

    describe Story, "on destroy" do
      before(:each) do
        create_element(:story=>@story)
      end
 
      it "should delete its elements" do
         element_count = @story.elements.count
         lambda {
           @story.destroy
         }.should change(Element, :count).by(-element_count)
      end
    end
  end
end
