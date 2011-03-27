class LinkedinUserEducation < ActiveRecord::Base
  belongs_to :linkedin_user
  
  def initialize(hash)
    super process_hash(hash)	
  end
  
  def process_hash(education)
    if (education.nil?)
      return nil
    end
    if dt = education.delete('start_date')
      education['start_date'] = dt['year']
    end
    if dt = education.delete('end_date')
      education['end_date']   = dt['year']
    end
    education['education_id'] = education['id']
    education
  end
 	
  def compare_hash(hash_from_database,hash_from_server)
    result = Hash.new
    hash_from_database.each { |key,value|
      if key.to_s != 'linkedin_user_id'.to_s && key.to_s != 'created_at'.to_s && key.to_s != 'updated_at'.to_s && value != hash_from_server[key]
        result[key] = hash_from_server[key]
      end
    }
    result
  end

 
  def update_attributes(hash)
    hash = process_hash(hash)
    hash = compare_hash(self.attributes, hash)
    super(hash)
  end

end
