class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments do |t|
      t.references :ship, :null=>false
      t.references :game, :null=>false

      t.integer :lives, :null=>false
      t.string :orientation, :null=>false
      t.integer :positions, :array => true

      t.timestamps
    end
  end
end
