# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FacebookPage do
  describe "on create_from_proxy" do
    it "should fail silently if passed nil data" do
      FacebookPage.create_from_proxy(nil).should_not raise_error
    end
    
    it "should fail silently if proxy object does not have required attributes" do
      FacebookPage.create_from_proxy(Object.new).should_not raise_error
    end
  end
end