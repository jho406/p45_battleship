module Battleship
  #Contains battleship actions for interacting with the API (the opponent)
  module Actions
    #starts the game, by calling the api.
    def start(game)
      return game if game.platform_id

      api = self.game_platform.new({:email => game.email, :name => game.full_name})
      api.register
      game.platform_id = api.id
      receive_initial_nuke(game, coord_to_pos(api.counter_nuke))
      return game
    end

    # when the player nukes the gaming platform
    def nuke!(game, position)
      #todo: code smell, may be some depedancies on game implementation.
      return if game.over?
      api = game_platform.new(:id => game.platform_id)

      api.nuke(pos_to_coord(position))
      #which creates a turn hit/miss # todo, add a transformer
      turns = [game.turns.create!(:position => position, :status => api.status, :attacked => true)]

      if api.status == 'lost'
        game.win!
        return turns
      end
      #i didn't win yet, i also receive a hit
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
      #todo: this could be better. We need this because, we want to keep
      #start as non-destructive incase other libs use it. Since game can't be saved yet
      #rails throw a 'parent not saved error'. We can solve it by extending
      #the has_many associations, but this is good for now.
      return game.deployments.lock_on(position) if game.persisted?

      game.deployments.to_a.find do |deployed|
          deployed.positions.include?(position)
      end
    end

    def damage_and_report!(target)
      return 'miss' unless target
      target.damage!
      return 'hit'
    end

    def damage_and_report(target, game)
      return 'miss' unless target

      #we need the below because lives will start off as nil when not persisted.
      target.lives ||= 0
      target.lives-=1

      game.lives ||= 0
      game.lives-=1
      return 'hit'
    end
  end
end