# $Id$
class PopulateGlobalCategories < ActiveRecord::Migration
  def self.up
    Category.create(:name=>"General", :user_id => 0)
  end

  def self.down
    Category.delete_all "user_id = 0"
  end
end
