class LinkedinUserPatentInventor < ActiveRecord::Base
  belongs_to :linkedin_user_patents,:foreign_key => "linkedin_user_patents_id"

   def self.process_hash(author)
    if (author.nil?)
      return nil
    end
   author['linkedin_id'] = author.delete('id')
   
    return author
  end

  def self.from_authors(author)
    author = self.process_hash(author)
    li = self.new(author)
    li
  end
 def self.delete(patent_id)
    self.delete_all(["linkedin_user_patents_id = ?" , patent_id])

  end
end
