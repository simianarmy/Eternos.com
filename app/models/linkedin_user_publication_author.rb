class LinkedinUserPublicationAuthor < ActiveRecord::Base
  belongs_to :linkedin_user_publications_id,:foreign_key => "linkedin_user_publications_id"

  def self.process_hash(author)
    if (author.nil?)
      return nil
    end
    author['linkedin_id'] = author.delete('id')
    return author
  end

  def self.from_authors(author)
   
    author['linkedin_id'] = author.delete('id')
    li = self.new(author)
    li
  end
 def self.delete(publication_id)
    self.delete_all(["linkedin_user_patents_id = ?" , publication_id])

  end
end
