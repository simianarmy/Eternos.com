class LinkedinUserCurrentPosition < ActiveRecord::Base
  belongs_to :linkedin_user, :foreign_key => "linkedin_user_id"

  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])
  end
  
  def initialize(hash)
     hash = process_hash(hash)	
     super(hash)
   end
   
  def process_hash(position)
    if (position.nil?)
      return nil
    end
    
    if !position['start_date'].nil?
      position['start_date'] = build_date_from_year_month position['start_date']
    end

    if !position['end_date'].nil?
      position['end_date'] = build_date_from_year_month position['end_date']
    end
    position['company_name'] = position['company']['name']
    position['company_id'] = position['company']['id']
    position['company_industry'] = position['company']['industry']
    position.delete('company')
    position
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
  
  protected 
  
  def build_date_from_year_month(data)
    dt = data['year']
    if data['month']
      dt +=  '-' + data['month'] + '-1'
    end
    dt
  end

end
