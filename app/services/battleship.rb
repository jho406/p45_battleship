module Battleship
  attr_accessor :game_platform
  ##todo, play in rake
  BOARD_SIZE = 10
  SHIPS = [
    {:name=>"Carrier",    :length=>5},
    {:name=>"Battleship", :length=>4},
    {:name=>"Destroyer",  :length=>3},
    {:name=>"Submarine",  :length=>2},
    {:name=>"Patrol Boat",:length=>1},
    {:name=>"Submarine",  :length=>2},
    {:name=>"Patrol Boat",:length=>1}
  ]

  STEP = {:horizontal => 1, :vertical => 10}

  extend self

  def seed(model)
    model.create(SHIPS)
  end

  def cell_count
    BOARD_SIZE**2
  end

  def ship_ids
    #todo: implement rails cache
    Ship.pluck(:id)
  end

  def start(game)
    # just deal with reducing dependacies on this fornow redo controllerts to Game.start
    #maybe move half to the Game class???
    return game if game.p45_id
  ##todo: module include in model, it has to know something about turn and game...
  ## have it be included in both models rather than depending on dependancy injection...
    api = game_platform.new({:email => game.email, :name => game.full_name})
    api.register
    game.p45_id = api.id
    game.turns.new({:position => coord_to_pos(api.counter_nuke)})

    return game
  end

  def nuke!(game, index)
    return game if game.over?
    api = game_platform.new(:id => game.p45_id)

    api.nuke(pos_to_coord(index))
    game.turns.create!(:position=>index, :status=> api.status, :attacked=>true)
    #which creates a turn hit/miss # todo, add a transformer

    #check if i won, aka if its game over for them but not us
    if api.status == 'lost'
      game.win!
      return game
    end

    #i didn't win yet, i also receive a hit
    #todo: eager load assoications via the controller
    index = coord_to_pos(api.counter_nuke)
    receive_nuke!(game, index)

    return game
  end

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

  def coord_to_pos(coord)
    if [coord[:x], coord[:y]].max > (BOARD_SIZE-1)
      raise ArgumentError, "coordinates out of range"
    end

    coord = coord.to_options
    coord[:y] * BOARD_SIZE + coord[:x]
  end

  def pos_to_coord(index)
    if index > BOARD_SIZE**2 - 1
      raise ArgumentError, "position out of range"
    end

    coord = index.divmod(BOARD_SIZE)
    {:x => coord[0], :y => coord[1]}
  end

  def expand_pos(args)
    pos = args[:position]
    length = args[:length]
    orientation = args[:orientation].to_sym || :horizontal

    step = STEP[orientation]
    # debugger
    if pos+(length-1)*step > BOARD_SIZE**2 ||
      orientation == :horizontal && (pos%10)+length > BOARD_SIZE
      raise ArgumentError, "pos and length out of range"
    end

    (length-1).times.inject([pos]) do |memo|
      memo.push(memo.last + step)
    end
  end
end