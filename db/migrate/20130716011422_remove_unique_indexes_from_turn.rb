class RemoveUniqueIndexesFromTurn < ActiveRecord::Migration
  def up
    remove_index :turns, :name => 'per_player_position_unique'
  end
  def down
    add_index :turns, [:game_id, :attacked, :position], :unique => true, :name => 'per_player_position_unique'
  end
end
