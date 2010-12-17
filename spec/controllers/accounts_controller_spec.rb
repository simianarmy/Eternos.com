require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do
  ActionController::Integration::Session
  
  describe "on create affiliate account post" do
    describe "with required parameters" do
      def required_params
        {:email => Faker::Internet.email}
      end
      
      def post_info
        post :aff_create, @params.merge({:user => required_params})
      end
      
      fixtures :subscriptions, :subscription_plans
      
      before(:each) do 
        @params = {:plan => 'Free'}
      end
      
      it "should create an account with just an email address" do
        lambda {
          post_info
        }.should change(User, :count).by(1)
      end
      
      it "should assign a special placeholder password" do
        post_info
        assigns[:user].should be_using_coreg_password
      end
      
      it "should assign a placeholder name only if none sent" do
        post_info
        assigns[:account].user.first_name.should == 'New'
        post :aff_create, @params.merge({:user => required_params.merge({:first_name => 'douchenick'})})
        assigns[:account].user.first_name.should == 'douchenick'
      end
      
      it "should save gender in profile" do
        post :aff_create, @params.merge({:user => required_params.merge({:profile => {:gender => 'male'}})})
        assigns[:account].user.profile.gender.should == 'male'
      end
      
      it "should save birthdate in profile" do
        post :aff_create, @params.merge({:user => required_params.merge({:profile => {
          'birthday(1i)' => '1900', 'birthday(2i)' => '1', 'birthday(3i)' => '23'
        }})})
        assigns[:account].user.profile.birthday.year.should == 1900
      end
      
      describe "with address" do
        before(:each) do
          Region.stubs(:find_by_name).returns(stub(:id => 1, :country => stub(:id => 2)))
          Country.stubs(:find_by_alpha_2_code).returns(stub(:id => 111))
        end
        
        it "should save correct region id from valid state param" do
          post :aff_create, @params.merge({:user => required_params}.merge({:address_book => {
            :address_attributes => {:postal_code => "123", :street_1 => 'fun town', :city => 'shooberg', :state => 'oregon'}
          }}))
          assigns[:account].user.address_book.addresses.should have(1).thing
        end
        
        it "should save correct country from valid country param" do
          post :aff_create, @params.merge({:user => required_params}.merge({:address_book => {
            :address_attributes => {:postal_code => "123", :street_1 => 'fun town', :city => 'shooberg', :country_code => "US"}
          }}))
          assigns[:account].user.address_book.addresses.should have(1).thing
        end
        
        it "should save correct address without street address param" do
          post :aff_create, @params.merge({:user => required_params}.merge({:address_book => {
            :address_attributes => {:postal_code => "123", :city => 'shooberg', :country_code => "US"}
          }}))
          assigns[:account].user.address_book.addresses.first.city.should == 'shooberg'
        end
        
        it "should save correct address with country code and country id" do
          post :aff_create, @params.merge({:user => required_params}.merge({:address_book => {
            :address_attributes => {:postal_code => "123", :city => 'shooberg', :country_code => "US", :country_id => 840}
          }}))
          assigns[:account].user.address_book.addresses.first.should be_valid
        end
        
        it "should save correct address with country code and country id and region id" do
          post :aff_create, @params.merge({:user => required_params}.merge({:address_book => {
            :address_attributes => {:postal_code => "123", :city => 'shooberg', :country_id => 840,
              :region_id => 4163}
          }}))
          assigns[:account].user.address_book.addresses.first.should be_valid
          assigns[:account].user.address_book.addresses.first.region_id.should == 4163
        end
        
        it "should allow full address" do
          post :aff_create, @params.merge({:user => required_params.merge({
            :profile => {
              'birthday(1i)' => "1979", 'birthday(2i)' => "01", 'birthday(3i)' => "01", :gender => "female"
            }, 
            :first_name => 'test', :last_name => 'best'
            })}.merge({
              :address_book => {
                :address_attributes => {
                  :city => "Kent", :country_code => "US", :postal_code => "11111", :state => "Washington"
                }
                }}))
           assigns[:account].user.address_book.addresses.should have(1).thing
        end
        
        it "should save cellphone in address_book" do
          post :aff_create, @params.merge({:user => required_params.merge({
            :profile => {'birthday(1i)' => "1979", 'birthday(2i)' => "01", 'birthday(3i)' => "01",
              :gender => "female", :cellphone => '123-3322'}, 
            :first_name => 'test', :last_name => 'best'
          })})
          assigns[:account].user.address_book.phone_numbers.should have(1).thing
        end
      end
      
      it "should receive an activation email with a link to the password entry page" do
        post_info
        # Don't know why we have to double uri-escape the email address, but that's how it 
        # shows up in these test emails...
        activation_link = Regexp.new(/\/activate\/\w+/)
        choose_pwd_link = Regexp.new(/\/choose_password$/)
        
        links = links_in_email(open_last_email_for(assigns[:user].email))

        links.select { |link| activation_link.match link }.should be_empty
        links.select { |link| choose_pwd_link.match link }.should_not be_empty
      end
      
      # it "should allow user to login with generated password" do
      #         post_info
      #         user = assigns[:user]
      #         pwd = user.generated_password
      #         UserSession.create(:login => user.login, :password => pwd).should be_true
      #       end
    end
  end
end
