class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :content, :null => false
      t.references :article, :null => false
    end
  end
  
  def self.down
    drop_table :comments
  end
end
