class LinkedinUserLanguage < ActiveRecord::Base

  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  def self.process_hash(language)
    if (language.nil?)
      return nil
    end
    RAILS_DEFAULT_LOGGER.info "hash : \n#{language.inspect}"
    language['language_name']        = language.delete('language')['name']
    if (!language['proficiency'].nil?)
      language['proficiency_name']     = language['proficiency']['name']
      language['proficiency_level']    = language['proficiency']['level']
      language.delete('proficiency')
    end
    
    language['language_id'] = language['id']
    return language
  end
  def self.from_languages(language)
    if language.nil?
      return nil
    end
    li = self.process_hash(language)
    li = self.new(language)

    li
  end
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])
    
  end
end
