# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe TimelineSearch do
  include TimelineSearchSpecHelper
  include ActivityStreamProxySpecHelper
  include UserSpecHelper
  include AddressBookSpecHelper
  include FeedHelper
  
    
  def setup_mock_data(member)
    @member = member
    Member.stubs(:find).with(@member.id).returns(@member)
    @member.stubs(:profile).returns(create_profile(:member => @member))
    @member.stubs(:address_book).returns(@ab = mock_model(AddressBook))
    @member.stubs(:activity_stream).returns(@as = mock_model(ActivityStream))
    @member.stubs(:backup_source).returns(@bs = mock_model(BackupSource))
    @searchlogic = mock('SearchLogic')
    @searchlogic.stubs(:deleted_at_null=)
    @searchlogic.stubs(:before).returns(@searchlogic)
    @searchlogic.stubs(:after).returns(@searchlogic)
    @searchlogic.stubs(:in_dates).returns(@searchlogic)
    @searchlogic.stubs(:sorted_desc).returns(@searchlogic)

#    @searchlogic.stubs(:all).returns()
    @as.stubs(:items).returns(@asi = mock('activity stream item'))
    @asi.stub_chain(:facebook, :searchlogic).returns(@searchlogic)
    @asi.stub_chain(:twitter, :searchlogic).returns(@searchlogic)
    @member.stub_chain(:contents, :media, :searchlogic).returns(@searchlogic)
    @member.stub_chain(:contents, :photos, :searchlogic).returns(@searchlogic)
    BackupEmail.stub_chain(:belonging_to_user, :searchlogic).returns(@searchlogic)
    FeedEntry.stub_chain(:belonging_to_user, :include_content, :searchlogic).returns(@searchlogic)
  end
  
  def setup_search_params
    # Setup all the required search mock data for one member
    @start_date = '2008-01-01'
    @before_start_date = '2007-01-01'
    @after_start_date = '2008-02-01'
    @end_date   = '2012-12-31'
  end
  
  def make_search(opts={})
    new_search(@member, @start_date, @end_date, opts)
  end

  describe "on new" do
    before(:each) do
      setup_search_params
      @member = mock_model(Member)
    end
    
    it "should return all types if no type param" do
      @search = make_search
      @search.search_types.should == TimelineSearch.type_action_map.keys
    end

    it "should return selected type if type param" do
      @search = make_search :type => "email"
      @search.search_methods.should == [TimelineSearch.type_action_map[:email]]
    end

    it "should return selected types if type param with multiple types" do
      @search = make_search :type => "email|twitter"
      @search.search_methods.should == [TimelineSearch.type_action_map[:email], 
      TimelineSearch.type_action_map[:twitter]]
    end

    it "should only return artifact types if artifact flag is set" do
      @search = make_search :artifact => true
      @search.search_methods.should == TimelineSearch.filter_action_map[:artifact]
    end

    it "should only return duration types if duration flag is set" do
      @search = make_search :duration => true
      @search.search_methods.should == TimelineSearch.filter_action_map[:duration]
    end
  end
  
  describe "searching" do
    include AddressBookSpecHelper
    
    before(:each) do
      setup_search_params
      @member = create_member
    end
    
    def create_family_item(member, attrs={})
      profile = member.profile || create_profile(:member => member)
      create_family({:profile => profile}.merge(attrs))
    end
    
    def create_facebook_item(member)
      as = member.activity_stream || create_activity_stream(:member => member)
      item = create_activity_stream_item(:activity_stream => as, :type => 'FacebookActivityStreamItem')
      # workaround since Fixjour stupidly creates new activity stream & member
      item.activity_stream = as
      item
    end
      
    def create_photo_item(member, attrs={})
      create_content({:type => :photo, :owner => member}.merge(attrs))
    end
    
    describe "with date range" do
      before(:each) do
        @search = make_search
      end
      
      describe "searching for duration data" do
        it "should return profile results if some profile items in range" do
          fam = create_family_item(@member, :birthdate => @after_start_date)
          @search.get_durations.should == [fam]
        end

        it "should return an address if in some range" do
          addr = create_address_book_address(@member)
          @search.get_durations.should == [addr]
        end
      end
      
      it "should return activity stream results if some in range" do
        fb = create_facebook_item(@member)
        fb.update_attribute(:published_at, @after_start_date)
        @search.get_facebook_items.should == [fb]
      end
      
      it "should not return photo if created date in range but not shot date" do
        photo = create_photo_item(@member)
        photo.update_attributes(:created_at => @after_start_date, :taken_at => @before_start_date)
        @search.get_images.should be_empty
      end
      
      it "should return photo if shot date in range" do
        photo = create_photo_item(@member)
        photo.update_attributes(:created_at => 5.years.ago, :taken_at => @after_start_date)
        @search.get_images.should == [photo]
      end
    end
    
    describe "with proximity option" do
      before(:each) do
        @fb = create_facebook_item(@member)
      end
      
      describe "searching in the past" do
        before(:each) do
          @search     = make_search(:proximity => 'past')
        end
        
        describe "with no items prior to the start date" do
          before(:each) do
            @fb.update_attribute(:published_at, @after_start_date)
          end
          
          it "should not return any events" do
            @search.get_facebook_items.should be_empty
          end
        end

      
        describe "with some items prior to the start date" do
          before(:each) do
            @fb.update_attribute(:published_at, @before_start_date)
          end

          it "should return some events" do
            @search.get_facebook_items.should_not be_empty
          end
        end
      end
      
      describe "searching in the future" do
        before(:each) do
          @search     = make_search(:proximity => 'future')
        end
        
        describe "with no items after to the start date" do
          before(:each) do
            @fb.update_attribute(:published_at, @before_start_date)
          end
          
          it "should not return any events" do
            @search.get_facebook_items.should be_empty
          end
        end

        describe "with some items after the start date" do
          before(:each) do
            @fb.update_attribute(:published_at, @after_start_date)
          end

          it "should return some events" do
            @search.get_facebook_items.should_not be_empty
          end
        end
      end
    end
  end

  # describe TimelineSearchFaker do
  #     def do_search(opts={})
  #       new_fake_search(@member, @start_date, @end_date, opts)
  #     end
  # 
  #     describe "on new" do
  #       it "should set default number of results to return to max" do
  #         do_search.num_results.should == TimelineSearch.max_results
  #       end
  #       
  #       it "should set number of results to return if in options" do
  #         do_search(:max_results => 10).num_results.should == 10
  #       end
  #     end
  # 
  #     describe "generating results" do
  #       describe "on range search" do
  #         it "should return array with max_results items" do
  #           @search = do_search
  #           @search.results.size.should be_close(TimelineSearch.max_results, 2)
  #         end
  # 
  #         it "should return media only if artifacts flag is set" do
  #           events = do_search(:artifact=>true).results
  #           events.should_not be_empty
  #           events.each do |e|
  #             ['facebook_activity_stream_item', 'photo', 'video'].should include e.type
  #           end
  #         end
  # 
  #         it "should return duration events only if duration flag is set" do
  #           events = do_search(:max_results => 10, :duration=>true).results
  #           events.should_not be_empty
  #           events.each do |e|
  #             ['address', 'job', 'school'].should include e.type
  #             if e.end_date
  #               e.end_date.should == Date.parse(@end_date)
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
end
