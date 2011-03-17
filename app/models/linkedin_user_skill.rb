class LinkedinUserSkill < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  def process_hash(skill)
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

  def initialize(hash)
    hash = process_hash(hash)	
    super(hash)
    
  end
 	
  def compare_hash(hash_from_database,hash_from_server)
    result = Hash.new
    hash_from_database.each { |key,value|
      if key.to_s != 'linkedin_user_id'.to_s && key.to_s != 'created_at'.to_s && key.to_s != 'updated_at'.to_s && value != hash_from_server[key]
        result[key] = hash_from_server[key]
      end
    }
    return result
  end

    
  def update_attributes(hash)
    hash = process_hash(hash)
    hash = compare_hash(self.attributes,hash)
    super(hash)
  end
end
