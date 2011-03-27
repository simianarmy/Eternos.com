class CreateLinkedinUserLanguages < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_languages do |t|
      t.string :language_name,:proficiency_level,:proficiency_name
      t.integer :linkedin_user_id, :null => false
      t.integer :language_id
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_languages
  end
end
