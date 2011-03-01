class LinkedinUserCertification < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"

  def self.process_hash(hash)
    if (hash.nil?)
      return nil
    end
	
		
	
	
    hash['authority_name'] = hash['authority']['name']
    hash['certification_id'] = hash['id']
	hash.delete('authority')
	hash.delete('id')
    return hash
  end

  def self.from_certification(certification)
    if certification.nil?
      return nil
    end
	
    certification = self.process_hash(certification)
    li = self.new(certification)
    li
  end
  
  def self.update_certification(certification,user_id)
    if certification.nil?
      return nil
    end
    certification = self.process_hash(certification)
	
    li = self.find_all_by_certification_id_and_linkedin_user_id(certification['certification_id'], user_id).first
    li.update_attributes(certification)
    li.save
    
  end
end
