class LinkedinUserEducation < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  def self.process_hash(education)
    if (education.nil?)
      return nil
    end
    education['start_date'] = education.delete('start_date')['year']
    education['end_date']   = education.delete('end_date')['year']
	education['education_id'] = education['id']
    return education
  end


  def self.from_educations(education)
    if education.nil?
      return nil
    end
    li = self.process_hash(education)
    li = self.new(education)
    li
  end
  def self.update_educations(education,user_id)
    if education.nil?
      return nil
    end

    education = self.process_hash(education)
    li = self.find_all_by_education_id_and_linkedin_user_id(education['education_id'], user_id).first
    li.update_attributes(education)
    li.save
  end
end
