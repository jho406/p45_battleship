require 'set'
module Battleship
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

  STEP = {:horizontal => 1, :vertical=>10}

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

  def start(args)
    email                 = args[:email]
    name                  = args[:full_name]
    model                 = args[:model]
    deployments_attributes = args[:deployments_attributes]
    game = model.new(
      :email => email,
      :full_name => name,
      :deployments_attributes => deployments_attributes
    )

    game.valid?
    # debugger
    return game if game.errors.keys.to_set != [:p45_id, :turns, :p45_response].to_set
##todo: module include in model, it has to know something about turn and game...
## have it be included in both models rather than depending on dependancy injection...
    api = P45.new({:email => email, :name => name})
    #p45 to hash
    game.assign_attributes({
      :p45_id=>api.id,
      :p45_response => api.response,
      :turns_attributes => [{
        :p45_response => api.response.to_s,
        :position => coord_to_pos(transform_coord(api.response))
      }]
    })
    game.valid?

    return game
  end

  def nuke!(game, index)
    api = P45.new(:id=>game.id)

    api.nuke(pos_to_coord(index))
    game.turn.create!(:position=>index)

    coord = transform_coord(api.response)
    index = coord_to_pos(coord)
    game.turn.create!(:position=>index)
  end

  def coord_to_pos(coord)
    if [coord[:x], coord[:y]].max > (BOARD_SIZE-1)
      raise ArgumentError, "coordinates out of range"
    end

    coord = coord.to_options
    coord[:x] * BOARD_SIZE + coord[:y]
  end

  def pos_to_coord(index)
    if index > BOARD_SIZE**2 - 1
      raise ArgumentError, "position out of range"
    end

    coord = index.divmod(BOARD_SIZE)
    {:x => coord[0], :y => coord[1]}
  end

  def transform_coord(resp)
    resp = resp.to_options
    {:x => resp[:x], :y => resp[:y]}
  end

  def expand_pos(args)
    pos = args[:position]
    length = args[:length]
    orientation = args[:orientation] || :horizontal
    step = STEP[orientation]

    if pos+(length-1)*step > BOARD_SIZE**2 ||
      orientation == :horizontal && (pos%10)+length > BOARD_SIZE
      raise ArgumentError, "pos and length out of range"
    end

    (length-1).times.inject([pos]) do |memo|
      memo.push(memo.last + step)
    end
  end

  # def collision?(ships)
  #   if ship.length == 2
  #     pos = []
  #     while(ship = [ships[0], ships[1]].min_by{:first}) do
  #       pos.push(ship.unshift)
  #     end
  #   end

  #   collision?()
  # end

end