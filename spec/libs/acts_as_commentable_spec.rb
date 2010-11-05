ActiveRecord::Schema.define(:version => 0) do  
  create_table :scratches, :force => true do |t| 
    t.string :name
  end 
end

class Scratch < ActiveRecord::Base
  acts_as_commentable
end

describe "ActsAsCommentable" do
  before(:each) do
    @object = Scratch.new
  end
  
  it "should respond to comments" do
    @object.should respond_to(:comments)
  end

  it "should respond to add_comment" do
    @object.should respond_to(:add_comment)
end

