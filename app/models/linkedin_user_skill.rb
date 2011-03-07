class LinkedinUserSkill < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
   def self.process_hash(skill)
    if (skill.nil?)
      return nil
    end
    skill['name'] = skill['skill']['name']
	 skill['yeard_experience'] = Integer(skill['years']['id'])
    skill['proficiency_level'] = skill['proficiency']['level']
	 skill['skill_id'] = skill.delete('id')
	 skill.delete('skill')
    skill.delete('years')
    skill.delete('proficiency')
    return skill
  end

  def self.from_skills(skill)
    if skill.nil?
      return nil
    end
    skill = self.process_hash(skill)
    li = self.new(skill)
    li
  end
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end
end
