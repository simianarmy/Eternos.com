class LinkedinUserLanguage < ActiveRecord::Base

  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  def process_hash(language)
    if (language.nil?)
      return nil
    end
    
    language['language_name']        = language.delete('language')['name']
    if (!language['proficiency'].nil?)
      language['proficiency_name']     = language['proficiency']['name']
      language['proficiency_level']    = language['proficiency']['level']
      language.delete('proficiency')
    end
    
    language['language_id'] = language['id']
    return language
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
