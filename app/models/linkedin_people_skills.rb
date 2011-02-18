class LinkedinPeopleSkills < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"
  def self.from_skills(skill)
  if skill.nil?
	return nil
  end
    li = self.new
    li.name = skill['skill']['name']
    li.yeard_experience = Integer(skill['years']['id'])
    li.proficiency_level = skill['proficiency']['level']
    li
  end
end
