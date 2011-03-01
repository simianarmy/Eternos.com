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
  def self.update_publications(publication,user_id)
    if publication.nil?
      return nil
    end
    authors = publication.delete('authors')
    publication = self.process_hash(publication)
   # li = self.find_all_by_publication_id_and_linkedin_user_id(publication['publication_id'],user_id).first
    #li.update_attributes(publication)
    #li.save

    #li_author = LinkedinUserPublicationAuthor.find_all_by_linkedin_user_publications_id(li.id).first
    #li_author.update_attributes(authors)
    #li_author.save

  end
end
