class LinkedinUserPatent < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  has_many   :linkedin_user_patent_inventors, :class_name  => "LinkedinUserPatentInventor"

  def process_hash(patent)
    if (patent.nil?)
      return nil
    end
    patent['date_of_issue'] = patent['date']['year'] + '-' + patent['date']['month']+ '-' + patent['date']['day']
    patent.delete('date')
    patent['office_name'] = patent.delete('office')['name']
    patent['status_name'] = patent['status']['name']
    patent['status_id'] = patent['status']['id']
    patent['patent_id'] = patent.delete('id');
    patent.delete('status')
    if (!patent['inventors'].nil?)
       patent.delete('inventors')
    end	
    return patent
  end

  def add_patent_inventors_from_people(patent_inventors)
    if patent_inventors.nil? || patent_inventors['inventor'].nil?
      return
    end
    if Integer(patent_inventors['total']) > 1
      patent_inventors['inventor'].each { |patent_inventor|
        
        li = LinkedinUserPatentInventor.new(patent_inventor['person'])
        linkedin_user_patent_inventors << li
    
      }
    else
      li = LinkedinUserPatentInventor.new(patent_inventors['inventor']['person'])
      linkedin_user_patent_inventors << li
    
    end
  end

 def initialize(hash)
    
    hash = process_hash(hash)	
    
    super(hash)
    
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
