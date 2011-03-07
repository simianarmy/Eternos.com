class LinkedinUserPosition < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"

   def self.process_hash(position)
    if (position.nil?)
      return nil
    end
	position['position_id'] = position['id']
	position.delete('id')
    if !position['start_date'].nil?
	  start_date = position.delete('start_date')
      position['start_date'] = String(start_date['year']) +'-'+ String(start_date['month']) +'-1'
    end
	if !position['end_date'].nil?
	  end_date = position.delete('end_date')
      position['end_date'] = String(end_date['year']) +'-'+ String(end_date['month']) +'-1'
    end
    RAILS_DEFAULT_LOGGER.info "after hash process :#{position.inspect} \n"
	
	
    return position
  end

  def self.from_positions(position)
    
    
    position.delete('company')
    position = self.process_hash(position)
    li = self.new(position)
    li
  end
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end
end
