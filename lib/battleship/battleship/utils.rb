module Battleship
    module Utils

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


      def seed(model)
        model.create(SHIPS)
      end

      def cell_count
        BOARD_SIZE**2
      end

      def board_size
        BOARD_SIZE
      end

      def ship_ids
        #todo: remove
        Ship.pluck(:id)
      end

      def coord_to_pos(coord)
        if [coord[:x], coord[:y]].max > (board_size-1)
          raise ArgumentError, "coordinates out of range"
        end

        coord = coord.to_options
        coord[:y] * board_size + coord[:x]
      end

      def pos_to_coord(index)
        if index > cell_count - 1
          raise ArgumentError, "position out of range"
        end

        coord = index.divmod(board_size)
        {:x => coord[0], :y => coord[1]}
      end

      def expand_pos(args)
        pos = args[:position]
        length = args[:length]
        orientation = args[:orientation].to_sym || :horizontal

        step = STEP[orientation]
        if pos+(length-1)*step > cell_count ||
          orientation == :horizontal && (pos%10)+length > board_size
          raise ArgumentError, "pos and length out of range"
        end

        (length-1).times.inject([pos]) do |memo|
          memo.push(memo.last + step)
        end
      end
  end
end