require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProfilesController do
  fixtures :users
  
  it_should_behave_like "a member is signed in"
  
  describe "handling GET /profiles" do

    before(:each) do
      @profile = mock('ProfilePresenter')
      ProfilePresenter.stubs(:new).returns(@profile)
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should assign the found profile for the view" do
      do_get
      assigns[:profile].should == @profile
    end
  end
  
  describe "handling PUT /profiles/update" do

    before(:each) do
      @profile = mock('ProfilePresenter')
      ProfilePresenter.stubs(:new).returns(@profile)
    end
    
    describe "with successful update" do
      
      def do_put
        @profile.expects(:save).returns(true)
        put :update, :profile => {}
      end

      it "should update the found profile" do
        do_put
        assigns(:profile).should equal(@profile)
      end

      it "should assign the found profile for the view" do
        do_put
        assigns(:profile).should equal(@profile)
      end

      it "should redirect to the profile" do
        do_put
        response.should redirect_to(profiles_url)
      end

    end
    
    describe "with failed update" do

      def do_put
        @profile.expects(:save).returns(false)
        put :update, :profile => {}
      end

      it "should re-render 'index'" do
        do_put
        response.should render_template('index')
      end

    end
  end

end
