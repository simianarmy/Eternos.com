# $Id$

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

ActiveRecord::Schema.define(:version => 0) do  
  create_table :scratches, :force => true do |t| 
    t.string :name
  end 
end

class Scratch < ActiveRecord::Base
  acts_as_av_attachable
end

describe "ActsAsAvAttachable" do
  before(:each) do
    @object = Scratch.new
  end
  
  it "should respond to av_attachment" do
    @object.should respond_to(:av_attachment)
  end
  
  it "should respond to recording" do
    @object.should respond_to(:attached_recording)
  end
end
