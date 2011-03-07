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
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end
end
