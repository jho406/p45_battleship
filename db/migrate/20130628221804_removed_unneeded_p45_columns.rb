class RemovedUnneededP45Columns < ActiveRecord::Migration
  def up
    remove_column :turns, :p45_response
    remove_column :games, :p45_response
  end

  def down
    add_column :turns, :p45_response, :text, :null => false
    add_column :games, :p45_response, :text, :null => false
  end
end
