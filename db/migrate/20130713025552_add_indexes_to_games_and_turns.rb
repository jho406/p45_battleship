class AddIndexesToGamesAndTurns < ActiveRecord::Migration
  def change
    add_index :games, :platform_id, :unique => true
    add_index :turns, [:game_id, :attacked, :position], :unique => true, :name => 'per_player_position_unique'
  end
end
