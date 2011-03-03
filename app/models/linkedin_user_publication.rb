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
    if publication_authors.nil? || publication_authors['publication_author'].nil?
      return
    end
    if Integer(publication_authors['total']) > 1
      publication_authors['author'].each { |publication_author|
        li = LinkedinUserPublicationAuthor.from_authors(publication_author)
        linkedin_user_publication_authors << li
      }
    else
      li  = LinkedinUserPublicationAuthor.from_authors(publication_authors['author'])
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
    #li.add_publication_authors_from_people(authors)
    li
  end
 def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end
end
