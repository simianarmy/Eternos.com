class LinkedinUserMemberUrlResource < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
   
  def self.from_member_urls(member_url_resources)
    if member_url_resources.nil?
      return nil
    end
    li = self.new(member_url_resources)
    li
  end
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end
end
