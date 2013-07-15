require 'spec_helper'

describe Battleship::Utils do
  context '.ship_attributes' do
    it 'should return ship attributes' do
      Battleship.ships_attributes.should eql(Battleship::SHIPS)
    end
  end

  context '.cell_count' do
    it 'should return the total number of cells' do
      Battleship.cell_count.should eql(Battleship::BOARD_SIZE**2)
    end
  end

  context '.coord_to_pos' do
    it 'should convert a hash of coords into a index' do
      Battleship.coord_to_pos({:x=>1, :y=>2}).should eq(21)
    end

    it 'should throw an error if the coord is beyond the limits of the boardsize' do
      expect{Battleship.coord_to_pos({:x=>1, :y=>11})}.to raise_error(ArgumentError)
    end
  end

  context '.pos_to_coord' do
    it 'should convert an index into a hash of coordinates' do
      Battleship.pos_to_coord(99).should eql({:x=>9, :y=>9})
    end

    it 'should throw an error if the index is beyond the limits of the boardsize' do
      expect{Battleship.pos_to_coord(100).should}.to raise_error(ArgumentError)
    end
  end

  context '.collision?' do
    it 'should return true if 2 arrays have duplicates' do
      Battleship.collision?([1,2,3,3,4,5]).should be_true
    end

    it 'should return false if 2 arrays are void of duplicates' do
      Battleship.collision?([1,2,3,4,5,6]).should be_false
    end
  end

  context '.expand_pos' do
    it 'should translate a ship into its occupying indexes' do
      positions = Battleship.expand_pos(
        :position => 0,
        :length => 10,
        :orientation => :horizontal
      )

      positions.should eql((0..9).to_a)
    end

    it 'should throw and error if ship is out of range' do
      args = {
        :position => 5,
        :length => 10,
        :orientation => :horizontal
      }
      expect{Battleship.expand_pos(args)}.to raise_error(ArgumentError)

      args[:orientation] = :vertical
      args[:position] = 90
      expect{ Battleship.expand_pos(args) }.to raise_error(ArgumentError)
    end

  end
end