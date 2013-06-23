class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :name, :null => false
      t.integer :length, :null => false

      t.timestamps
    end
  end
end
