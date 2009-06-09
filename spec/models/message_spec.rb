# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/common_settings_spec_helper')

module MessageSpecHelper
  def valid_attributes
    {:member=>mock_model(Member), :title => 'foo', :message => 'message', :tag_s => 'foo,fee fi,fa,fa'}
  end
end

describe "Message" do
  it "should be searchable by text" do
    @member = mock_model(Member)
    Message.expects(:search).with('foo').returns(@res = [mock_model(Message)])
    Message.search_text('foo', @member).should be_eql(@res)
  end
end

describe Message, "on create" do
  include MessageSpecHelper
  
  before(:each) do
    @message = Message.new
  end
  
  it "should be invalid without required attributes" do
    @message.should_not be_valid
    @message.attributes = valid_attributes
    @message.should be_valid
  end
  
  it "should be created" do
    lambda{ 
      @message.attributes = valid_attributes
      @message.save
      @message.should_not be_new_record
    }.should change(Message,:count).by(1)
  end
  
  describe "with common settings" do
    before(:each) do 
      @object = Message.new
      @object.attributes = valid_attributes
    end
    
    it_should_behave_like "an object with common settings on create"
  end
end

describe Message, "on update" do
  include MessageSpecHelper
  
  before(:each) do
    @object = @message = Message.new(valid_attributes)
  end
  
  it "should be invalid without required attributes" do
    @message.should be_valid
    @message.title = ''
    @message.should_not be_valid
    @message.should have_at_least(1).error_on(:title)
  end
  
  it_should_behave_like "an object with common settings on update"
  
end

describe "with decorations" do  
  before(:each) do
    @message = create_message
    @content = create_content(:type => :photo)
  end
  
  it "should create decoration" do
    lambda {
      @message.decorate @content
    }.should change(Decoration, :count).by(1)
  end
  
  it "should add decoration to message" do
    lambda {
      @message.decorate @content
    }.should change(@message.decorations, :count).by(1)
  end
  
  it "should add only unique decorations" do
    lambda {
      2.times {@message.decorate @content}
    }.should change(@message.decorations, :count).by(1)
  end
end

describe Message, "on destroy" do  
  before(:each) do
    @message = create_message
    @message.decorate create_content(:type => :photo)
  end
  
  it "should destroy decorations" do
    lambda {
      @message.destroy
    }.should change(Decoration, :count).by(-@message.contents.size)
  end
end
