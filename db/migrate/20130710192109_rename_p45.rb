class RenameP45 < ActiveRecord::Migration
  def change
    rename_column :games, :p45_id, :platform_id
  end
end
