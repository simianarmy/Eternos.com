class LinkedinPeoplePatents < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"
  has_many   :linkedin_people_patent_inventors, :class_name  => "LinkedinPeoplePatentInventors"

  def add_patent_inventors_from_people(patent_inventors)
    if patent_inventors.nil? || patent_inventors['inventor'].nil?
      return
    end
    if Integer(patent_inventors['total']) > 1
      patent_inventors['inventor'].each { |patent_inventor|
        li = LinkedinPeoplePatentInventors.from_authors(patent_inventor)
        linkedin_people_patent_inventors << li
      }
    else
      li  = LinkedinPeoplePatentInventors.from_authors(patent_inventors['inventor']['person'])
      linkedin_people_patent_inventors << li
    end
  end

  def self.from_patents(patent)
  if patent.nil?
	return nil
  end
    patent['date_of_issue'] = patent['date']['year'] + '-' + patent['date']['month']+ '-' + patent['date']['day']
    patent.delete('date')
    patent['office_name'] = patent.delete('office')['name']
    patent['status_name'] = patent['status']['name']
    patent['status_id'] = patent['status']['id']
    patent.delete('status')

    
    inventors = patent.delete('inventors')

    li = self.new(patent)
    li.add_patent_inventors_from_people(inventors)
    li
  end
  
end
