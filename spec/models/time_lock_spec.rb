# $Id$

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TimeLock do
  include TimeLockSpecHelper
  before(:each) do
    @time_lock = new_time_lock
  end

  it "should be expired without date" do
    @time_lock.unlock_on = nil
    @time_lock.should be_expired
  end
  
  describe "on create" do  
    it "should create an object" do
      lambda {
        @time_lock.save
      }.should change(TimeLock, :count).by(1)
    end
  
    it "should not allow a date in the past" do
      @time_lock.unlock_on = Date.today - 1
      lambda {
        @time_lock.save
      }.should_not change(TimeLock, :count)
    end
  end

  describe "on update" do
    before(:each) do
       @time_lock = create_time_lock
    end
  
    it "should not save without polymorphic association object" do
      @time_lock.lockable = nil
      @time_lock.save
      @time_lock.should have(2).errors_on(:lockable)
    end
  
    it "should not save with invalid date" do
      @time_lock.unlock_on = nil
      @time_lock.save
      @time_lock.should_not be_valid
    end
  end

  describe "" do
    describe "with date" do
      before(:each) do
        @time_lock = create_time_lock
      end

      it "should be expired once current date reaches or passes unlock date" do
        @time_lock.should_not be_expired
        @time_lock.unlock_on.should > Date.today
        @time_lock.unlock_on = Date.today
        @time_lock.should be_expired
        @time_lock.unlock_on = 1.day.ago
        @time_lock.should be_expired
      end
    end
  end
end

describe DeathLock, "on create" do
  include TimeLockSpecHelper
  before(:each) do
    @time_lock = new_time_lock(:type => :death_lock)
  end
  
  it "should create an object" do
    debugger
    lambda {
      @time_lock.save
    }.should change(DeathLock, :count).by(1)
  end

  it "should never expire" do
    @time_lock.save
    # Need to refetch for STI to change object type
    @death_lock = DeathLock.find(@time_lock.id)
    @death_lock.unlock_on = 1.day.ago
    @death_lock.should_not be_expired
  end


  describe "on update" do  
    it "should be valid with any date" do
      @time_lock = create_time_lock(:type => :death_lock)
      @time_lock.unlock_on = 1.day.ago
      @time_lock.should be_valid
    end
  end
end

describe "TimeLocked object" do
  include TimeLockSpecHelper
  before(:each) do
    @lockable = new_time_locked_object
  end
  
  it "should respond to time_lock" do
    @lockable.should respond_to(:time_lock)
  end
  
  it "should respond to time_lock_changed?" do
    @lockable.should respond_to(:time_lock_changed?)
  end
  
  it "should be unlocked by default" do
    @lockable.should be_unlocked
  end
  
  describe 'on create' do
    it "should not create a time lock object without time lock attributes" do
      lambda {
        @lockable.save
      }.should_not change(TimeLock, :count)
    end
    
    it "should create time lock object if time lock attributes set" do
      @lockable.new_time_lock_attributes = valid_time_lock_attributes
      @lockable.save
      @lockable.time_lock.should be_an_instance_of TimeLock      
    end
    
    it "should return lockable class object" do
      @lockable.time_lock.lockable.should be_eql(@lockable)
    end
    
    it "should create death lock object if death lock attributes set" do
      @lockable.new_time_lock_attributes = valid_time_lock_attributes
      @lockable.save
      @lockable.reload.time_lock.should be_an_instance_of DeathLock
    end
  end
  
  describe "on update" do
    describe "when time locked" do
      before(:each) do
        @lockable.new_time_lock_attributes = valid_time_lock_attributes
        @lockable.save
        @lockable.should be_date_locked
      end

      it "should replace time lock on assignment" do
        @death_lock = create_time_lock(:type => :death_lock, :lockable => @lockable)
        @lockable.time_lock = @death_lock
        @lockable.time_lock.should == @death_lock
        @lockable.save
        @lockable.time_lock.should == @death_lock
      end
      
      it "time lock attribute should be death lock when updated with death lock attributes" do
        @lockable.update_attributes(:time_lock_attributes => valid_time_lock_attributes)
        @lockable.reload.time_lock.should be_an_instance_of DeathLock
      end
      
      it "should delete time lock when updated with unlocked attribute" do
        @lockable.update_attributes(:time_lock_attributes => valid_time_lock_attributes)
        @lockable.reload.time_lock.should be_nil
      end
    
      it "should return changed status if time lock type changed" do
        # Not changing anything here
        @lockable.update_attributes(:time_lock_attributes => valid_time_lock_attributes)
        @lockable.time_lock_changed?.should be_false
        # Changing unlock date
        @lockable.update_attributes(:time_lock_attributes => valid_time_lock_attributes.merge(
          :unlock_on => 1.year.from_now))
        @lockable.time_lock_changed?.should be_false
        # From date to death lock
        @lockable.update_attributes(:time_lock_attributes => valid_time_lock_attributes)
        @lockable.time_lock_changed?.should be_true
        # From death to death lock
        @lockable.update_attributes(:time_lock_attributes => valid_time_lock_attributes)
        @lockable.time_lock_changed?.should be_false
        # From death to date lock
        @lockable.update_attributes(:time_lock_attributes => valid_time_lock_attributes)
        @lockable.time_lock_changed?.should be_true
        # From date to no lock
        @lockable.update_attributes(:time_lock_attributes => valid_time_lock_attributes)
        @lockable.time_lock_changed?.should be_true
      end
    end
  end
end

  