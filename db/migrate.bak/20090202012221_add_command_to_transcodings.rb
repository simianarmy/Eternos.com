class AddCommandToTranscodings < ActiveRecord::Migration
  def self.up
    change_table :transcodings do |t|
      t.string :command
      t.text :command_expanded
    end
  end

  def self.down
    change_table :transcodings do |t|
      t.remove :command, :command_expanded
    end
  end
end
