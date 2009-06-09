# $Id$
class AddTimelineToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :start_at, :datetime
    add_column :stories, :end_at, :datetime
    add_column :stories, :theme_id, :integer, :null => false, :default => 0, :references => nil
  end

  def self.down
    remove_column :stories, :start_at
    remove_column :stories, :end_at
    remove_column :stories, :theme_id
  end
end
