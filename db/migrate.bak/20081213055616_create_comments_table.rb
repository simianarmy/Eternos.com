# $Id$
class CreateCommentsTable < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true do |t|
        t.column :title, :string, :limit => 50, :default => ""
        t.column :comment, :text, :default => ""
        t.timestamps
        t.integer :commentable_id, :references => nil
        t.string :commentable_type
        t.column :user_id, :integer, :default => 0, :null => false, :references => nil
      end
  end

  def self.down
    drop_table :comments
  end
end
