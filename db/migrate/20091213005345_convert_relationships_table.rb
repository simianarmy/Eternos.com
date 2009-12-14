class ConvertRelationshipsTable < ActiveRecord::Migration
  #class Relationship < ActiveRecord::Base; end
  def self.up
    add_column :relationships, :profile_id, :integer
    Relationship.all.each do |rel|
      if m = Member.find(rel.user_id) rescue nil
        rel.update_attribute(:profile_id, m.profile.id) if m.profile
      end
    end
    remove_index :relationships, :name => "index_relationships_on_user_id"
    remove_column :relationships, :user_id
    add_index "relationships", ["profile_id"], :name => "index_relationships_on_profile_id"
  end

  def self.down
    remove_column :relationships, :profile_id
    add_column :relationships, :user_id
    add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"
  end
end
