# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe ActivityStreamProxy do
  def mock_attachment_data
    {'type' => 'test', 'data' => 'foofoo'}
  end
  
  it "should save attachment on assignment" do
    @proxy = ActivityStreamProxy.new
    @proxy.attachment = mock_attachment_data
    @proxy.attachment_data.should == mock_attachment_data
  end
end