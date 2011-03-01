class LinkedinUserLanguage < ActiveRecord::Base

  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  def self.process_hash(language)
    if (language.nil?)
      return nil
    end
	RAILS_DEFAULT_LOGGER.info "hash : \n#{language.inspect}"
    language['language_name']        = language.delete('language')['name']
    language['proficiency_name']     = language['proficiency']['name']
    language['proficiency_level']    = language['proficiency']['level']
    language.delete('proficiency')
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
  def self.update_languages(language,user_id)
    if language.nil?
      return nil
    end

    language = self.process_hash(language)
    li = self.find_all_by_language_id_and_linkedin_user_id(language['language_id'],user_id).first
    li.update_attributes(language)
    li.save
  end
end
