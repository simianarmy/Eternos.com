# $Id$

describe "a content child", :shared => true do
  before(:each) do
    @klass = @param_sym.to_s.camelize.constantize
  end
  
  it "index action should render index template" do
     get :index
     response.should render_template(:index)
   end

   it "index action should display list of contents owned by user" do
     Content.expects(:find).returns([@content])
     get :index
     assigns[@param_sym.to_s.pluralize.to_sym].should_not be_empty
     assigns[@param_sym.to_s.pluralize.to_sym].each {|c| c.owner.should be_eql(@user) }
   end

   it "show action should render show template" do
     get :show, :id => @content.id
     response.should render_template(:show)
   end

   it "destroy action should destroy model and redirect to index action" do
     delete :destroy, :id => @content.id
     response.should redirect_to(:action => :index)
     Content.exists?(@content.id).should be_false
   end
end