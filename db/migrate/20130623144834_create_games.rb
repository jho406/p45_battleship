class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :p45_id, :null => false
      t.string :full_name, :null => false
      t.string :email, :null => false
      t.boolean :over, :null => false, :default=>false
      t.text :p45_response, :null => false

      t.timestamps
    end
  end
end
