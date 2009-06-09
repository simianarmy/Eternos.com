# $Id$

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module LockableObject
  # A dummy class for mocking the activerecord connection class
  class Connection; end
  class LockableEmpty < ActiveRecord::Base; end
  class Lockable < ActiveRecord::Base
    acts_as_time_locked
  end
  
  def get_lockable
    connection = mock('Connection', :columns => [], :indexes => [])
    Lockable.stubs(:connection).returns(connection)
    
    returning Lockable.new do |lockme|
      lockme.stubs(:id).returns(1)
    end
  end
end

describe "ActiveRecord Instance" do
  include LockableObject
  
  describe "Empty" do
    before(:each) do
      connection = mock('Connection', :columns => [], :indexes => [])
      LockableObject::LockableEmpty.stubs(:connection).returns(connection)
    end

    it "should not have time_lock method" do
      LockableObject::LockableEmpty.new.should_not respond_to(:time_lock)
    end
  end

  describe "Standard" do
    before(:each) do
      connection = mock('Connection', :columns => [], :indexes => [])
      LockableObject::Lockable.stubs(:connection).returns(connection)
      @lockable = LockableObject::Lockable.new
    end

    it "should have time_lock method" do
      @lockable.should respond_to(:time_lock)
    end
  end
  
  describe "on create" do
    # The following examples fail from 'stack level too deep' error...something to do with
    # connection stubbing?
    # Now doing tests in common_settings_spec_helper so that I can use real activerecord objects
    
    # it "should return options for select" do
    #      @lockable.time_lock_select_options.should_not be_empty
    #    end
    #            
    #            it "should have time_lock_type method" do
    #              @lockable.methods.include?('time_lock_type').should be_true
    #            end
  end
end