class AddStatusToTurn < ActiveRecord::Migration
  def change
    add_column :turns, :status, :string,  :null=>false, :default => 'miss' #hit, miss
  end
end
