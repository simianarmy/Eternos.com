# $Id$

# Shared specs that seemed like too much to put in spec_helper.rb

module CommonSettingsSpecHelper
  def valid_tag_attributes(tags='foo')
    {:tag_s => tags}
  end
  
  def valid_timelock_attributes(options={})
    new_record = options.delete(:new)
    type = options.delete(:time_lock_type) || TimeLock.default
    
    options = {:type => type, :unlock_on => 1.year.from_now}.merge(options)
    {"#{new_record ? 'new_' : ''}time_lock_attributes".to_sym => options}
  end
  
  def valid_common_settings(options={})
    time_period_attributes(1.month.ago, Time.now).merge(valid_tag_attributes).merge(
      valid_timelock_attributes(options)).merge(options)
  end
  
  def add_time_lock(object, type=TimeLock.date_locked)
    object.update_attributes(valid_timelock_attributes(:time_lock_type => type))
  end
end


describe "an object with common settings on create", :shared => true do
  include CommonSettingsSpecHelper
  
  describe "with time lock" do
    it "should fail if time lock attributes not valid" do
      @object.attributes = valid_common_settings.merge(
        valid_timelock_attributes(:new=>true, :time_lock_type => TimeLock.date_locked, 
        :unlock_on=>nil))
      @object.save
      @object.should_not be_valid
    end
   
    it "should save if valid time lock attributes" do
      @object.attributes = valid_common_settings(:new=>true, 
        :time_lock_type => TimeLock.date_locked)
      @object.save.should be_true
      @object.reload.time_lock_type.should >= 0
    end
  
    describe "with non-default time lock attribute" do
      it "should create time lock object if dated time lock attribute selected" do
        lambda {
          @object.attributes = valid_common_settings(:new=>true, 
            :time_lock_type => TimeLock.date_locked)
          @object.save
        }.should change(TimeLock, :count).by(1)
      end
    
      it "should create time lock object with proper sti type" do
        @object.attributes = valid_common_settings(:new=>true, 
          :time_lock_type => TimeLock.date_locked)
        @object.save
        @object.time_lock.type.should == "TimeLock"
      end
    
      it "should create death lock object if death time lock attribute selected" do
        lambda {
          @object.attributes = valid_common_settings(:new=>true, 
            :time_lock_type => TimeLock.death_locked)
          @object.save
        }.should change(DeathLock, :count).by(1)
      end
    
      it "should create death lock object with proper sti type" do
        @object.attributes = valid_common_settings(:new=>true, 
          :time_lock_type => TimeLock.death_locked)
        @object.save
        @object.reload.time_lock.type.should == "DeathLock"
      end
    end
  end
  
  describe "with tags" do
    it "should have get_owner method" do
      @object.should respond_to(:get_owner)
    end
    
    it "should save tags attribute" do
      @object.tag_list.should be_blank
      @object.attributes = valid_common_settings(:new=>true)
      @object.save
      @object.reload.tag_list.should_not be_blank
    end
    
    it "should save tags with user id" do
      @object.attributes = valid_common_settings(:new=>true)
      @object.save
      @object.taggings.first.user_id.should == @object.get_owner.id
    end
  end
end

describe "a new object with categories", :shared => true do
  describe "with global category" do
     it "should belong to a global category" do
        @object.category.should be_global
      end
    end
    
  describe "with user-created category" do
    fixtures :categories
    
    it "should have a non-global category" do
      @object.attributes = {:category_id => categories(:not_global).id}
      @object.save
      @object.category.should_not be_global
    end
  end
  
  describe "with new category" do
    it "should create category" do
      lambda {
        @object.attributes = {:new_category_name => 'mxxplx'}
        @object.save
      }.should change(Category, :count).by(1)
    end
  end
end

describe "an object with common settings on update", :shared => true do
  include CommonSettingsSpecHelper
  
  describe "with no time lock" do
    it "should create time lock object if non-default selected" do
      lambda {
        add_time_lock(@object)
      }.should change(TimeLock, :count).by(1)
    end
  end
    
  describe "with existing time lock" do
    before(:each) do
      add_time_lock(@object)
    end
    
    it "should not replace time lock if adding same type" do
      @object.expects(:update_time_lock).never
      add_time_lock(@object)
    end
    
    it "should replace time lock if selection changed" do
      lambda {
        add_time_lock(@object, TimeLock.death_locked)
      }.should_not change(TimeLock, :count)
    end
    
    it "should remove time lock if selection changed to 'not using' option" do
      lambda {
        add_time_lock(@object, TimeLock.unlocked)
      }.should change(TimeLock, :count).by(-1)
    end
  end
end