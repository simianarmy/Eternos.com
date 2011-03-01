class CreateLinkedinUserPatents < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_patents do |t|
      t.integer   :linkedin_user_id, :null => false
      t.text      :title,:summary,:status_name,:office_name,:url,:patent_id
      t.string    :number,:status_id
      t.date      :date_of_issue
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_patents
  end
end
