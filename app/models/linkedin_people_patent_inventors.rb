class LinkedinPeoplePatentInventors < ActiveRecord::Base
  belongs_to :linkedin_people_publications_id,:foreign_key => "linkedin_people_publications_id"

  def self.from_authors(author)

    author['linkedin_id'] = author.delete('id')
    li = self.new(author)

    li
  end
end
