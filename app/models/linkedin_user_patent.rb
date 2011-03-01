class LinkedinUserPatent < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  has_many   :linkedin_user_patent_inventors, :class_name  => "LinkedinUserPatentInventor"

  def self.process_hash(patent)
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

    return patent
  end

  def add_patent_inventors_from_people(patent_inventors,linkedin_user_patents_id)
    if patent_inventors.nil? || patent_inventors['inventor'].nil?
      return
    end
    if Integer(patent_inventors['total']) > 1
      patent_inventors['inventor'].each { |patent_inventor|
        LinkedinUserPatentInventor.from_authors(patent_inventor)
        
      }
    else
       LinkedinUserPatentInventor.from_authors(patent_inventors['inventor']['person'])
     
    end
  end

  def self.from_patents(patent)
    if patent.nil?
      return nil
    end
     
    inventors = patent.delete('inventors')
    patent = self.process_hash(patent)

    li = self.new(patent)
    #li.add_patent_inventors_from_people(inventors)
    li
  end
  def self.update_patents(patent,user_id)
    if patent.nil?
      return nil
    end
    inventors = patent.delete('inventors')
    patent = self.process_hash(patent)

    li = self.find_all_by_patent_id_and_linkedin_user_id(patent['patent_id'],user_id).first
    li.update_attributes(patent)
    li.save

    #li_inventor = LinkedinUserPatentInventor.find_all_by_linkedin_user_patents_id(li.id).first
    #li_inventor.update_attributes(inventors)
    #li_inventor.save
  end
end
