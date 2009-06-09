# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "profiles/index" do
  
  before(:each) do
    @profile = mock('ProfilePresenter')
    @profile.stubs(:profile).returns(mock_model(Profile))
    @profile.stubs(:address_book).returns(mock_model(AddressBook))
    @profile.stubs(:errors).returns([])
    assigns[:profile] = @profile
  end
  
  it "should display profile tabs" do
    @controller.template.should_receive(:render).with(:partial => 'general')
    @controller.template.should_receive(:render).with(:partial => 'personal')
    @controller.template.should_receive(:render).with(:partial => 'careers')
    @controller.template.should_receive(:render).with(:partial => 'education')
    #@controller.template.expects(:render).with(:partial => 'medical')
    render 'profiles/index'
    response.should have_tag('ul#tabcontrol1') do
      with_tag "li#general_tab"
      with_tag "li#personal_tab"
      with_tag "li#careers_tab"
      with_tag "li#education_tab"
      #with_tag "li#medical_tab"
    end
  end
end