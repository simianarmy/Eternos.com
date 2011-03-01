class LinkedinUserMemberUrlResource < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
   
  def self.from_member_urls(member_url_resources)
    if member_url_resources.nil?
      return nil
    end
    li = self.new(member_url_resources)
    li
  end
  def self.update_member_urls(member_url_resources,user_id)
    if member_url_resources.nil?
      return nil
    end

    
    li = self.find_all_by_url_and_linkedin_user_id(member_url_resources['url'], user_id).first
    li.update_attributes(member_url_resources)
    li.save
  end
end
