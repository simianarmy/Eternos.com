# $Id$
require File.dirname(__FILE__) + '/../spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/contents_spec_helper')

describe ContentsController do
  include ContentSpecHelper
  integrate_views
  
  it_should_behave_like "a member is signed in"
  
  before(:each) do
    @content = create_content(:type => :photo, :owner => @member)
  end
  
  it "should have at least one content belonging to user" do
    @user.contents.should_not be_empty
  end
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "index action should display list of contents owned by user" do
    get :index
    assigns[:contents].should_not be_empty
    assigns[:contents].each {|c| c.owner.should be_eql(@user) }
  end
  
  it "show action should render show template" do
    get :show, :id => @content.id
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "edit action should render edit template" do
    get :edit, :id => @content.id
    response.should render_template(:edit)
  end
  
  it "update action should render rjs error when model is invalid" do
    @content.stubs(:valid?).returns(false)
    ajax_update :id => @content.id, :content => {:title => ''}, :domId => 'poop'
    assert_rjs :replace_html, 'notice'
  end
  
  it "update action should highlight field if valid" do
    @content.stubs(:update_attributes).returns(true)
    params = {:id => @content.id, :content => {:title => 'ass'}, :domId => 'poop'}
    ajax_update params
    assert_rjs :visual_effect, :highlight, 'poop', :duration => 2.0
  end
  
  it "destroy action should destroy model and redirect to index action" do
    delete :destroy, :id => @content.id
    response.should redirect_to(contents_url)
    Content.exists?(@content.id).should be_false
  end
  
  def ajax_update(params={})
    xhr :post, :update, params
  end
end

describe ContentsController, "on create from ajax/flash uploader component" do
  integrate_views
  include ContentSpecHelper
  
  it_should_behave_like "a member is signed in"
   
  it "should display json error when params are empty" do
    xhr :post, :create, :content => {}, :user_id => @user.id
    response_is_failure.should be_true
  end
  
  it "should display json error if required params missing" do
    Content.any_instance.stubs(:valid?).returns(false)  
    ajax_create_content
    response_is_failure.should be_true
  end

  it "should display json error when save fails" do
    Content.any_instance.stubs(:save!).returns(false)
    ajax_create_content
    response_is_failure.should be_true
  end
 
  it "should return new object id in json response on success" do
    ajax_create_content
    response_to_json['id'].should > 0
  end
  
  it "should display json success when model valid and file saved" do
    @user.contents.delete_all
    ajax_create_content
    response_is_success.should be_true
    @user.contents.reload.should_not be_empty
  end
  
  it "should create file on disk" do
    create_video
    @content = Content.find(response_to_json['id'])
    File.exist?(@content.full_filename).should be_true
  end
  
  def ajax_create_content
    xhr :post, :create, :content => {:content_type => Mime::TEXT.to_s, 
      :uploaded_data => text_file},
      :Filename => 'foo.txt', :user_id=>@user.id
  end
  
  def create_photo
    xhr :post, :create, :content => {:content_type => 'image/jpeg',
      :uploaded_data => image_file},
      :Filename => 'drinkycrow.jpg', :user_id=>@user.id
  end
  
  def create_video
    xhr :post, :create, :content => {:content_type => 'video/quicktime',
      :uploaded_data => video_file},
      :Filename => 'small_movie.mov', :user_id=>@user.id
  end
  
  def response_is_success
    response_to_json['status'] == 'success'
  end
  
  def response_is_failure
    response_to_json['status'] == 'error'
  end
end

describe ContentsController, "on edit_selection" do
  #fixtures :all
  integrate_views
  include ContentSpecHelper
  
  it_should_behave_like "a member is signed in"
  
  before(:each) do
    @content = @content = create_content(:type => :photo, :owner => @member)
  end
  
  it "should display error if no contents found matching request ids" do
    Content.expects(:find_all_by_id).returns([])
    post :edit_selection, :content => {:ids => "1"}
    assigns[:contents].should be_empty
    flash[:error].should_not be_empty
  end
  
  it "should return collection of contents matching request ids" do
    Content.expects(:find_all_by_id).with(['1','2','3']).returns([@content])
    post :edit_selection, :content => {:ids => '1,2,3'}
    assigns[:contents].size.should == 1
  end
end

describe ContentsController, "on update_selection" do
#  fixtures :all
  integrate_views
  include ContentSpecHelper
  it_should_behave_like "a member is signed in"
  
  before(:each) do
    Content.expects(:find_by_id).with('1').returns(@content1=mock('Content'))
    Content.expects(:find_by_id).with('2').returns(@content2=mock('Content'))
    Content.expects(:find_by_id).with('3').returns(@content3=mock('Content'))
    [@content1, @content2, @content3].each {|c| c.stubs(:save).returns(true)}
  end
  
  it "save action should update all items and redirect to index" do
    @content1.expects(:update_attributes).with(content_attributes['1'], anything)
    @content2.expects(:update_attributes).with(content_attributes['2'], anything)
    @content2.expects(:tag_list).with("fee pee", @member)
    @content3.expects(:update_attributes).with(content_attributes['3'], anything)
    @content3.expects(:tag_list).with("foo shee", @member)
    content = content_attributes
    content['2']['tag_list'] = "fee pee"
    content['3']['tag_list'] = "foo shee"
    do_save({}, content)
    response.should redirect_to(contents_path)
  end
  
  it "should assign global tags to each content" do
    [@content1, @content2, @content3].each {|c| c.stubs(:update_attributes).returns(true)}
    @content1.expects(:tag_list).with('foo fee fa', @member)
    @content2.expects(:tag_list).with('foo fee fa', @member)
    @content3.expects(:tag_list).with('foo fee fa', @member)
    do_save :tag_list => 'foo fee fa'
  end
    
  it "should assign global permissions to each content" do
    @content1.expects(:update_attributes).with(has_entry(privacy_attributes))
    @content2.expects(:update_attributes).with(has_entry(privacy_attributes))
    @content3.expects(:update_attributes).with(has_entry(privacy_attributes))
    do_save privacy_attributes
  end
  
  def do_save(params={}, content=content_attributes)
    post :update_selection, :contents => params, :content => content
  end
  
  def content_attributes
    { '1' => {'title' => 'first one'}, 
      '2' => {'title' => 'second title'},
      '3' => {'description' => 'co co channel'}}
  end
  
  def privacy_attributes
    {'privacy_settings' => {'authorization' => '2'}}
  end
end