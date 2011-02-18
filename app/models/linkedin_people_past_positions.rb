class LinkedinPeoplePastPositions < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_positions(position)
    if !position['start_date'].nil?
      position['start_date'] = position['start_date']['year'] +'-'+ position['start_date']['month'] +'-1'
    end

    if !position['end_date'].nil?
      position['end_date'] = position['end_date']['year'] +'-'+ position['end_date']['month'] +'-1'
    end
    position['company_name'] = position['company']['name']
    position['company_id'] = position['company']['id']
    position['company_industry'] = position['company']['industry']
    position.delete('company')
    
    li = self.new(position)
    li
  end
end
