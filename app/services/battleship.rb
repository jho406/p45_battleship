module Battleship
  BOARD_SIZE = 10
  SHIPS = [
    {:name=>"Carrier", :length=>5},
    {:name=>"Battleship", :length=>4},
    {:name=>"Destroyer", :length=>3},
    {:name=>"Submarine", :length=>2},
    {:name=>"Patrol Boat", :length=>1},
    {:name=>"Submarine", :length=>2},
    {:name=>"Patrol Boat", :length=>1}
  ]

  STEP = {:horizontal => 1, :vertical=>10}

  extend self

  def seed(model)
    model.create(SHIPS)
  end

  def ship_ids
    #todo: implement rails cache
    Ship.pluck(:id)
  end

  def start(args)
    email                 = args[:email]
    name                  = args[:name]
    model                 = args[:model]
    deployment_attributes = args[:deployment_attributes]

    api = P45.new({:email => email, :name => name})

    game = model.new(
      :email => email,
      :full_name => name,
      :p45_id=>api.id,
      :p45_response => api.response,
      :deployment_attributes => deployment_attributes,
      :turn_attributes => {
        :p45_response => api.response,
        :position => transform_coord(api.response)
      }
    )
  end

  def nuke(game, index)
    api = P45.new(:id=>game.id)

    api.nuke(pos_to_coord(index))
    coord = transform_coord(api.response)
    index = coord_to_pos(coord)
    game.turn.create(:position=>index)
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
      orientation == :horizontal && pos+length > BOARD_SIZE

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