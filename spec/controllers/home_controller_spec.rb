require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  let(:error_facebook_params) {
    {"fb_sig_app_id"=>"82855842117", "format"=>"fbml", "fb_sig_request_method"=>"GET", "fb_sig_locale"=>"en_US", "_method"=>"GET", "fb_sig_in_canvas"=>"1", "fb_sig_in_new_facebook"=>"1", "fb_sig_logged_out_facebook"=>"1", "fb_sig"=>"7d31c00010586c8f2214879181e11795", "installed"=>"1", "auth_token"=>"c049deb4b9bc1674384aec8853ee05dd", "fb_sig_added"=>"0", "fb_sig_country"=>"us", "fb_sig_api_key"=>"f9472d530015c3159828f0ef7c8b6d03", "fb_sig_time"=>"1300892575.3861"}
  }
  
  describe "with bad facebook params" do
    it "should handle parameters without crashing" do
      lambda {
        get :index, error_facebook_params
      }.should_not raise_error
    end
  
    it "should display an error on the signup page" do
      get :index, error_facebook_params
      flash[:error].should_not be_blank
      response.should render_template(:index)
    end
  end
end
