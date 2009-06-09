# $Id$
class CreateRegionsFromModel < ActiveRecord::Migration
  class TmpRegion < ActiveRecord::Base
  end
  def self.up
    create_table :tmp_regions do |t|
      t.column :country_id, :integer, :null => false, :references => nil
      t.column :group, :string # Currently only used by GB (United Kingdom)
      t.column :name, :string
      t.column :abbreviation, :string
    end
    say "Populating regions"
    RegionEnumerated.find(:all).each do |c|
      TmpRegion.create(:id => c.id, :name => c.name, :abbreviation => c.abbreviation, 
        :country_id => c.country_enumerated.id, :group => c.group)
    end
    rename_table :tmp_regions, :regions
  end

  def self.down
    drop_table :regions
  end
end
