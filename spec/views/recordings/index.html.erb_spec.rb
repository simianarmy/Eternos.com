# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/recordings/index.html.erb" do
  
  before(:each) do
    rec_audio = mock('Audio')
    rec_video = mock('Video')

    assigns[:recordings] = [rec_audio, rec_video]
  end

  it "should render list of recordings" do
  #  render "/recordings/index.html.erb"
  end
end

