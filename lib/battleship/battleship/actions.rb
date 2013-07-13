module Battleship
  module Actions
    def start(game)
      return game if game.platform_id

      api = self.game_platform.new({:email => game.email, :name => game.full_name})
      api.register
      game.platform_id = api.id
      game.turns.new({:position => coord_to_pos(api.counter_nuke), :attacked => false})

      return game
    end

    def nuke!(game, index)
      #todo: code smell, may be some depedancies on game implementation.
      return if game.over?
      api = game_platform.new(:id => game.platform_id)

      api.nuke(pos_to_coord(index))
      #which creates a turn hit/miss # todo, add a transformer

      turns = [game.turns.create!(:position => index, :status => api.status, :attacked => true)]

      #i didn't win yet, i also receive a hit
      #todo: eager load assoications via the controller
      index = coord_to_pos(api.counter_nuke)
      turns.push(game.receive_nuke!(index))

      return turns
    end
  end
end
