class ConvertRelationshipsTable < ActiveRecord::Migration
  #class Relationship < ActiveRecord::Base; end
  def self.up
    add_column :relationships, :profile_id, :integer
    Relationship.all.each do |rel|
      rel.update_attribute(:profile_id, rel.member.profile.id) if rel.member
      rel.save
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
