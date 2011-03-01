class CreateLinkedinUserPublications < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_publications do |t|
      t.integer   :linkedin_user_id, :null => false
      t.text      :title,:publisher_name,:summary,:url
      t.date      :date_of_issue
	  t.string	  :publication_id	
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_publications
  end
end
