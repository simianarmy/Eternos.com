class LinkedinPeopleEducations < ActiveRecord::Base

  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_educations(education)
  if education.nil?
	return nil
  end
    education['start_date'] = education.delete('start_date')['year']
    education['end_date']   = education.delete('end_date')['year']
    li = self.new(education)
    li
  end

end
