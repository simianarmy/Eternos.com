# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TimePeriod, "on new" do  
  before(:each) do
    @period = TimePeriod.new
  end

  it "should be empty" do
    @period.should be_empty
  end
  
  it "should return timeless string on string conversion" do
    @period.to_s.should == "Timeless"
  end
  
  it "should be invalid if end date without start date" do
    @period.end = Time.now
    @period.should_not be_valid
  end
end

describe TimePeriod, "with start time" do
  before(:each) do
    @start = Time.now
    @period = TimePeriod.new(@start)
  end
  
  it "should not be empty" do
    @period.should_not be_empty
  end
  
  it "should return single date+time on string conversion if time != 00" do
    @period.to_s.should == @start.to_formatted_s(:time_period_date_with_time)
  end
end

describe TimePeriod, "with different start and end times" do
  before(:each) do
    @start = 1.day.ago
    @end = Time.now
    @period = TimePeriod.new(@start, @end)
  end
  
  it "should contain start & end dates on string conversion" do
    @period.to_s.should =~ / to /
  end
  
  it "should be invalid if end date before start date" do
    @period.beginning = Time.now
    @period.end = 1.day.ago
    @period.should_not be_valid
  end
end

describe TimePeriod, "with start and end times on same day" do
  before(:each) do
    @start = Time.now
    @period = TimePeriod.new(@start, @end)
  end
  
  it "should contain single date on string conversion when dates equal" do
    @period.to_s.should_not =~ / to /
  end
  
  it "should countain both dates with times on string conversion when dates equal but times different" do
    @period = TimePeriod.new(Time.now-1, Time.now)
    @period.to_s.should =~ / to /
  end
end
