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
  
    describe "on backup_finished!" do
      it "should save backup state" do
        @member.create_backup_state
        @info = {:job_id => 1}
        @member.backup_state.expects(:finished!).with(@info)
        @member.backup_finished!(@info)
      endrequire "../../app/controllers/account_settings_controller"
      
    
      it "should save backup state even in none exists" do
        @info = {:job_id => 1}
        BackupState.expects(:new).returns(@bs)
        @bs.expects(:finished!).with(@info)
        @member.backup_finished!(@info)
       end
     end
     
    it "should need backup by default" do
      Member.needs_backup(1.day.ago).should == [@member]
    end

    it "should need_backup if last good backup date < cutoff" do
      @member.create_backup_state(:last_backup_finished_at => 3.days.ago, :in_progress => false)
      Member.needs_backup(1.week.ago).should == []
      Member.needs_backup(2.days.ago).should == [@member]
    end
   
     describe "without backup sites" do
       before(:each) do
         @member.create_backup_state(:last_backup_finished_at => 3.days.ago, :in_progress => false)
         Member.needs_backup(1.day.ago).should == [@member]
       end
     
       it "should not have backup targets by default" do
         Member.with_backup_targets.should == []
       end
   
       it "chained backup scopes should be empty" do
         Member.needs_backup(1.day.ago).with_backup_targets.should == []
       end
     end
   
     describe "with backup sites" do
       before(:each) do
         @member.backup_sources << create_backup_source(:member => @member)
       end
     
       it "should be in results of backup sites named scope" do
         Member.with_backup_targets.should == [@member]
       end
      
       it "should be in results of chained backup scopes" do
         @member.create_backup_state(:last_backup_finished_at => 3.days.ago, :in_progress => false)
         Member.needs_backup(1.day.ago).with_backup_targets.should == [@member]
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
       }.should change(Relationship, :count).by(1)
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
