require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do
  describe "on create affiliate account post" do
    describe "with required parameters" do
      def required_params
        {:email => Faker::Internet.email}
      end
      
      fixtures :subscriptions, :subscription_plans
      
      before(:each) do 
        @params = {:plan => 'Free'}
      end
      
      it "should create an account with just an email address" do
        lambda {
          post :aff_create, @params.merge({:user => required_params})
        }.should change(User, :count).by(1)
      end
      
      it "should assign a placeholder password only if none sent" do
        post :aff_create, @params.merge({:user => required_params})
        assigns[:account].user.password.should == User::PlaceholderPassword
        post :aff_create, @params.merge({:user => required_params.merge({:password => 'fooshnick'})})
        assigns[:account].user.password.should == 'fooshnick'
      end
      
      it "should assign a placeholder name only if none sent" do
        post :aff_create, @params.merge({:user => required_params})
        assigns[:account].user.first_name.should == 'first name'
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
      end
    end
  end
end
