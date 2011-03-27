class CreateLinkedinUserSkills < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_skills do |t|
      t.integer   :linkedin_user_id, :null => false
      t.string    :name,:proficiency_level,:skill_id
      t.integer   :yeard_experience
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_skills
  end
end
