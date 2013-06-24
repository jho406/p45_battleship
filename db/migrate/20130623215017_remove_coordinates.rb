class RemoveCoordinates < ActiveRecord::Migration
  def change
    remove_column :turns, :cell_x, :cell_y
  end
end
