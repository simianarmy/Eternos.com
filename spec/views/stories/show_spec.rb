# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "stories/show page" do
  fixtures :all
  it_should_behave_like "a member is signed in"
  
  before(:each) do
    assigns[:story] = @story = create_story(:member => @member)
    assigns[:recording] = create_recording(:member => @member)
    #@story.stubs(:errors).returns([])
    #@story.stubs(:has_photo?).returns(false)
    #@story.stubs(:categories).returns(mock('Category')))
    @story.stubs(:elements).returns([create_element(:story=>@story)])
  end
  
  it "should have div tag with id => story_photo_thumbnail in story_photo partial" do
    render 'stories/show'
    #response.should have_tag('div#story_photo_thumbnail')
  end
  
  it "should display a photo thumbnail if photo has a thumbnail" do
    @story.stubs(:has_photo?).returns(true)
    @photo = mock('Photo')
    @photo.stubs(:url).returns('img.url')
    @story.expects(:photo).returns(@photo)
    render 'stories/show'
    response.should have_tag("img.thumbnail[src*=img.url]")
  end
  
  it "should not display photo thumbnail if photo has no thumbnail" do
    @story.stubs(:has_photo?).returns(false)
    @story.expects(:photo).never
    render 'stories/show'
    response.should_not have_tag("img.thumbnail[src*=img.url]")
  end
  
  it "should render the elements partial with div tag w/ id => story_elements" do
    render 'stories/show'
  end
end
