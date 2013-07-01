class AddWonAndLivesToGame < ActiveRecord::Migration
  def change
    add_column :games, :won, :boolean, :null=> false, :default => false
    add_column :games, :lives, :integer, :null=> false, :default => 0
  end
end
