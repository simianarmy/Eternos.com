class LinkedinUserPublication < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  has_many   :linkedin_user_publication_authors, :class_name  => "LinkedinUserPublicationAuthor"

  def add_publication_authors_from_people(publication_authors)
    if publication_authors.nil? || publication_authors['author'].nil?
      return
    end
    if Integer(publication_authors['total']) > 1
      publication_authors['author'].each { |patent_inventor|
        li = LinkedinUserPublicationAuthor.new(patent_inventor['person'])
        print "id="
        print self.id 
        print "\n"
        li.linkedin_user_publications_id = self.id
        li.save

      }
    else
      li  = LinkedinUserPublicationAuthor.new(publication_authors['author']['person'])
      print "id="
      print self.id 
      print "\n"
	
      li.linkedin_user_publications_id = self.id
      li.save

    end
  end
  
  def process_hash(publication)
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
    if !publication['authors'].nil?
      publication.delete('authors')
    end
    return publication
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
