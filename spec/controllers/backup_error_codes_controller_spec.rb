require File.dirname(__FILE__) + '/../spec_helper'
 
describe BackupErrorCodesController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => BackupErrorCode.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    BackupErrorCode.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    BackupErrorCode.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(backup_error_code_url(assigns[:backup_error_code]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => BackupErrorCode.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    BackupErrorCode.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BackupErrorCode.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    BackupErrorCode.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BackupErrorCode.first
    response.should redirect_to(backup_error_code_url(assigns[:backup_error_code]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    backup_error_code = BackupErrorCode.first
    delete :destroy, :id => backup_error_code
    response.should redirect_to(backup_error_codes_url)
    BackupErrorCode.exists?(backup_error_code.id).should be_false
  end
end
