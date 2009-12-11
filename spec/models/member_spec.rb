# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe Member do
  before(:each) do
    @member = new_member
  end

  it "should have member role" do
    @member.role.should == 'Member'
  end

  it "should have relationships association" do
    @member.should respond_to :loved_ones
  end

  it "should have contents association" do
    @member.should respond_to :contents
  end
end

describe "on create" do
  include UserSpecHelper
  before(:each) do
    @member = make_member
  end

  it "should have a profile object" do
    @member.profile.should_not be_nil
  end

  it "should have an activity stream object" do
    @member.activity_stream.should_not be_nil
  end
end

describe Member, "once activated" do
  include UserSpecHelper
  include GuestSpecHelper
  
  before(:each) do
    @member = make_member
  end
   
  it "should be in live state" do
    @member.should be_live
  end
  
  it "should be a member object" do
    @member.should be_an_instance_of Member
  end
     
  describe "with backups" do
    it "should create backup state on first backup only" do
      lambda {
        @member.backup_in_progress!
        @member.backup_in_progress!
      }.should change(BackupState, :count).by(1)
    end
  
    it "backup_in_progress should update backup state" do
      @member.backup_in_progress!
      @member.backup_state.in_progress.should be_true
    end
    
    describe "needs_backup named_scope" do
      it "should need backup by default" do
        Member.needs_backup(1.day.ago).should == [@member]
      end

      it "should need_backup if last good backup date < cutoff" do
        @member.create_backup_state(:last_backup_finished_at => 3.days.ago, :in_progress => false)
        Member.needs_backup(1.week.ago).should == []
        Member.needs_backup(2.days.ago).should == [@member]
      end
    end
  
    describe "on backup_finished!" do
      before(:each) do
        @info = {:job_id => 1}
        @member.stubs(:backup_state).returns(@bs = mock_model(BackupState))
      end
      
      it "should save backup state" do
        @bs.stubs(:first_time_data_available?).returns(false)
        @bs.expects(:finished!).with(@info)
        @member.backup_finished!(@info)
      end
      
      it "should save backup state even in none exists" do
        @bs.expects(:finished!).with(@info)
        @bs.stubs(:first_time_data_available?).returns(false)
        @member.backup_finished!(@info)
      end
    
      it "should email member the 1st time backup items saved" do
        @bs.expects(:finished!).with(@info)
        @bs.stubs(:first_time_data_available?).returns(true)
        @member.backup_finished!(@info)
        ActionMailer::Base.deliveries.size.should == 2 # one for email creation too
      end
    end
     
     describe "without backup sites" do
       before(:each) do
         @member.create_backup_state(:last_backup_finished_at => 3.days.ago, :in_progress => false)
         Member.needs_backup(1.day.ago).should == [@member]
       end
     
       it "should not have backup data by default" do
         Member.with_data.should == []
       end
   
       it "chained backup named scopes should be empty" do
         Member.needs_backup(1.day.ago).with_data.should == []
       end
     end
   end
   
   describe "with guests" do
     before(:each) do
     end
     
     it "should only have relationships with guests" do
       create_guest_with_host(@member)
       @member.loved_ones.each do |u|
         u.should be_an_instance_of Guest
       end
     end

     it "should be able to create new relationships" do
       lambda {
         g = create_guest_with_host(@member)
       }.should change(GuestRelationship, :count).by(1)
     end
   
     it "should add a loved one on new relationshiop" do
        lambda {
          g = create_guest_with_host(@member)
          @member.add_guest(g, @circle)
        }.should change(@member.loved_ones, :size).by(1)
      end
   
     it "should be the host of a guest" do
       g = create_guest_with_host(@member)
       @member.loved_ones.each do |u|
         u.hosts.first.should be_eql(@member)
       end
     end
   end  
end
