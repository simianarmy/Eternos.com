class LinkedinPeoplePublications < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"
  has_many   :linkedin_people_publication_authors, :class_name  => "LinkedinPeoplePublicationAuthors"

   def add_publication_authors_from_people(publication_authors)
    if publication_authors.nil? || publication_authors['publication_author'].nil?
      return
    end
    if Integer(publication_authors['total']) > 1
      publication_authors['author'].each { |publication_author|
        li = LinkedinPeoplePublicationAuthors.from_authors(publication_author)
        linkedin_people_publication_authors << li
      }
    else
      li  = LinkedinPeoplePublicationAuthors.from_authors(publication_authors['author'])
      linkedin_people_publication_authors << li
    end
  end
  def self.from_publications(publication)
  if publication.nil?
	return nil
  end
    publication['date_of_issue']  = publication['date']['year'] + '-' + publication['date']['month']+ '-' + publication['date']['day']
    publication.delete('date')
    publication['publisher_name'] = publication['publisher']['name']
    publication.delete('publisher')
    authors = publication.delete('authors')
    li = self.new(publication)
    li.add_publication_authors_from_people(authors)
    li
  end
end
