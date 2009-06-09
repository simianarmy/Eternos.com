# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do
  before(:each) do 
    @category = Category.new
  end
  
  it "should not be valid without name" do
    @category.should_not be_valid
    @category.should have(1).error_on(:name)
    @category.name = 'foo'
    @category.should be_valid
  end
end

describe Category, "with fixtures" do
  fixtures :all
  
  it "globals should return default categories" do
    Category.find_globals(:all).should_not be_empty
    Category.find_globals(:first).global.should be_true
  end
end
