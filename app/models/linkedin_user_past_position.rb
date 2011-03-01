class LinkedinUserPastPosition < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
   def self.process_hash(position)
    if (position.nil?)
      return nil
    end
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

    return position
  end
  def self.from_positions(position)
    
    position = self.process_hash(position)
    li = self.new(position)
    li
  end
  def self.update_positions(position,user_id)
    if position.nil?
      return nil
    end

    position = self.process_hash(position)
    li = self.find_all_by_linkedin_user_id(user_id).first
    li.update_attributes(position)
    li.save
  end
end
