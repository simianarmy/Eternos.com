class LinkedinUserPosition < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"

  def initialize(hash)
    super process_hash(hash)	
  end
  
  def process_hash(position)
    if (position.nil?)
      return nil
    end
   
    position['position_id'] = position.delete('id')

    # converting dates to Y-M-1 string
    if !position['start_date'].nil?
      start_date = position.delete('start_date')
      position['start_date'] = LinkedinBackup.build_date_from_year_month start_date
    end
    if !position['end_date'].nil?
      end_date = position.delete('end_date')
      position['end_date'] = LinkedinBackup.build_date_from_year_month end_date
    end
    if (!position['company'].nil?)
      company = position.delete('company')
      position['company_name'] = company['name']
    	position['company_id'] = company['id']
	    position['company_industry'] = company['industry']
    end			
    return position
  end

  def compare_hash(hash_from_database,hash_from_server)
    result = Hash.new
    hash_from_database.each { |key,value|
      if key.to_s != 'linkedin_user_id'.to_s && key.to_s != 'created_at'.to_s && key.to_s != 'updated_at'.to_s && value != hash_from_server[key]
        result[key] = hash_from_server[key]
      end
    }
    return result
  end

  def update_attributes(hash)
    hash = process_hash(hash)
    hash = compare_hash(self.attributes,hash)
    super(hash)
  end
end
