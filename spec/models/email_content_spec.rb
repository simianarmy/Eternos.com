# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe EmailContent do
  include EmailSpecHelper

  before(:each) do
    @email = EmailContent.new
    @contents = raw_email
  end
  
  it "should contents to database if < s3 threshold size" do
    @email.save_contents('111', @contents)
    @email.s3_key.should be_nil
    @email.contents.should == @contents
  end
  
  it "should save to s3 if > threshold size" do
    EmailContent.stubs(:max_col_size).returns(1)
    @email.save_contents('111', @contents)
    @email.s3_key.should_not be_nil
  end
end