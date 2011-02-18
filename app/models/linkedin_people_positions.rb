class LinkedinPeoplePositions < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_positions(position)
  if position.nil?
	return nil
  end
    if !position['start_date'].nil?
      position['start_date'] = position['start_date']['year'] +'-'+ position['start_date']['month'] +'-1'
    end

    if !position['end_date'].nil?
      position['end_date'] = position['end_date']['year'] +'-'+ position['end_date']['month'] +'-1'
    end
    
    position.delete('company')
    li = self.new(position)
    li
  end
end
