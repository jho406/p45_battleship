module Battleship
  module Actions
    def start(game)
      return game if game.p45_id

      api = self.game_platform.new({:email => game.email, :name => game.full_name})
      api.register
      game.p45_id = api.id
      game.turns.new({:position => coord_to_pos(api.counter_nuke)})

      return game
    end

    def nuke!(game, index)
      return game if game.over?
      api = game_platform.new(:id => game.p45_id)

      api.nuke(pos_to_coord(index))
      #which creates a turn hit/miss # todo, add a transformer

      #check if i won, aka if its game over for them but not us
      if api.status == 'lost'
        game.win!
        return game
      end

      game.turns.create!(:position=>index, :status=> api.status, :attacked=>true)

      #i didn't win yet, i also receive a hit
      #todo: eager load assoications via the controller
      index = coord_to_pos(api.counter_nuke)
      receive_nuke!(game, index)

      return game
    end

    private

    def receive_nuke!(game, index)
      locked_on_ship = game.deployments.lock_on(index)
      status = damage_and_report!(locked_on_ship)
      game.lose! if game.over?
      #finally create the turn, but I didn't attack this turn so attacked == false
      game.turns.create!(:position=>index, :status => status, :attacked=>false)
    end

    def damage_and_report!(ship)
      return 'miss' if !ship
      ship.damage! #decrement the ship that got hit careful for less than zero
      return "hit"
    end
  end
end
