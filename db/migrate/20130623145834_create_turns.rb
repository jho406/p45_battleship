class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.references :game, :null => false

      t.integer :position, :null => false
      t.integer :cell_x, :null => false
      t.integer :cell_y, :null => false
      t.text :p45_response, :null => false

      t.timestamps
    end
  end
end
