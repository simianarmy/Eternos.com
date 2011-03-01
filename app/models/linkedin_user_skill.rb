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
  def self.update_skills(skill,user_id)
    if skill.nil?
      return nil
    end

    skill = self.process_hash(skill)
    li = self.find_all_by_skill_id_and_linkedin_user_id(skill['skill_id'],user_id).first
    li.update_attributes(skill)
    li.save
  end
end
