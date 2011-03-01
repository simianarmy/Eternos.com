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
  def self.update_authors(author,user_id)
    if author.nil?
      return nil
    end

    author = self.process_hash(author)
    li = self.find_all_by_linkedin_id_and_linkedin_user_id(author['linkedin_id'],user_id).first
    li.update_attributes(author)
    li.save
  end
end
