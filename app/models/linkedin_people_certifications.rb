class LinkedinPeopleCertifications < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_certification(certification)
  if certification.nil?
	return nil
  end
    li = self.new
    li.authority_name     = certification['authority']['name']
    li.certification_id   = certification['id']
    if !certification['end_date'].nil?
      li.end_date         = certification['end_date']
    end
    if !certification['start_date'].nil?
      li.start_date       = certification['start_date']
    end
    li.name               = certification['name']
    li.number             = certification['number']
    li
  end
end
