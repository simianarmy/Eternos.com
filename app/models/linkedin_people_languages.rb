class LinkedinPeopleLanguages < ActiveRecord::Base

  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_languages(language)
  if language.nil?
	return nil
  end
    language['language_name']        = language.delete('language')['name']
    language['proficiency_name']     = language['proficiency']['name']
    language['proficiency_level']    = language['proficiency']['level']
    language.delete('proficiency')
    language['language_id'] = language['id']
    li = self.new(language)

    li
  end
end
