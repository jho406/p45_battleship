collection @deployments
attributes :id, :orientation, :positions, :lives
node(:name){|deployment| deployment.ship.name}