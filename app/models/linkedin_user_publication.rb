class LinkedinUserPublication < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  has_many   :linkedin_user_publication_authors, :class_name  => "LinkedinUserPublicationAuthor"

  def self.process_hash(publication)
    if (publication.nil?)
      return nil
    end
    if !publication['date_of_issue'].nil?
      publication['date_of_issue']  = publication['date']['year'] + '-' + publication['date']['month']+ '-' + publication['date']['day']
    end
	
	
    publication.delete('date')
    publication['publisher_name'] = publication['publisher']['name']
    publication.delete('publisher')
    publication['publication_id'] = publication.delete('id')
    return publication
  end

  

  def add_publication_authors_from_people(publication_authors)
    if publication_authors.nil? || publication_authors['author'].nil?
      return
    end
    if Integer(publication_authors['total']) > 1
      publication_authors['author'].each { |patent_inventor|
        li = LinkedinUserPublicationAuthor.from_authors(patent_inventor['person'])
        #li.linkedin_user_publications_id = self.id
        linkedin_user_publication_authors << li

      }
    else
      li  = LinkedinUserPublicationAuthor.from_authors(publication_authors['author']['person'])
      #li.linkedin_user_publications_id = self.id
      linkedin_user_publication_authors << li

    end
  end

  
  def self.from_publications(publication)
    if publication.nil?
      return nil
    end
    
    authors = publication.delete('authors')
    publication = self.process_hash(publication)
    li = self.new(publication)
    
    li
  end
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])
    LinkedinUserPublicationAuthor.delete(self.id)
  end
end
