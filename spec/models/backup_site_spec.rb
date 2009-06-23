# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupSite do
  describe "on new" do
    before(:each) do
      @bs = new_backup_site
    end
    
    it "should return symbol for name" do
      @bs.name.should be_a Symbol
    end
  end
end