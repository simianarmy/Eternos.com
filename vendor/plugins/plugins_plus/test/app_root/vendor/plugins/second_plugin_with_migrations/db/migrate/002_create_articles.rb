class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title, :null => false
      t.text :content, :null => false
      t.references :author, :null => false
    end
  end
  
  def self.down
    drop_table :articles
  end
end
