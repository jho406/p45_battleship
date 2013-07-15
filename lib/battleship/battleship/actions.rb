module Battleship
  module Actions
    def start(game)
      return game if game.platform_id

      api = self.game_platform.new({:email => game.email, :name => game.full_name})
      api.register
      game.platform_id = api.id
      receive_initial_nuke(game, coord_to_pos(api.counter_nuke))
      return game
    end

    def nuke!(game, position)
      #todo: code smell, may be some depedancies on game implementation.
      return if game.over?
      api = game_platform.new(:id => game.platform_id)

      api.nuke(pos_to_coord(position))
      #which creates a turn hit/miss # todo, add a transformer
      turns = [game.turns.create!(:position => position, :status => api.status, :attacked => true)]

      return turns if game.over?
      #i didn't win yet, i also receive a hit
      #todo: eager load assoications via the controller
      position = coord_to_pos(api.counter_nuke)
      turns.push(receive_nuke!(game, position))

      return turns
    end

    private

    def receive_nuke!(game, position)
      target = lock_on(game, position)
      status = damage_and_report!(target)
      game.turns.create!(:position=>position, :status => status, :attacked=>false)
    end

    def receive_initial_nuke(game, position)
      target = lock_on(game, position)
      status = damage_and_report(target, game)
      game.turns.build(:position=>position, :status => status, :attacked=>false)
    end

    def lock_on(game, position)
      return game.deployments.lock_on(position) if game.persisted?

      game.deployments.to_a.find do |deployed|
          deployed.positions.include?(position)
      end
    end

    def damage_and_report!(target)
      return 'miss' unless target
      target.damage! #decrement the ship that got hit careful for less than zero
      return 'hit'
    end

    def damage_and_report(target, game)
      return 'miss' unless target
      target.lives ||= 0
      target.lives-=1

      game.lives ||= 0
      game.lives-=1
      return 'hit'
    end
  end
end