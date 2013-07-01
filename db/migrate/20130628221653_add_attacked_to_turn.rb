class AddAttackedToTurn < ActiveRecord::Migration
  def change
    add_column :turns, :attacked, :boolean, :null => false, :default => false
  end
end
