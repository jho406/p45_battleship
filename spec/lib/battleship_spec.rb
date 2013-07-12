require 'spec_helper'

describe Battleship do
  before(:each) do
    Battleship.game_platform = double("P45", :new => api)
  end

  after(:each) do
    Battleship.game_platform = MockPlatform
  end

  let(:turn){double('turn')}

  let(:turns) do
    double('turns', :'new'=>{}, :'create!' => turn)
  end

  let(:game) do
    double("game",
      :platform_id => nil,
      :prepared?  => true,
      :email => 'foo@foo.com',
      :full_name => 'foo',
      :turns => turns,
      :over? => false,
      :lose! => nil)
  end

  let(:api) do
    double("api",
      :register=>{},
      :id=>0,
      :counter_nuke=>{:x=>0, :y=>0},
      :nuke=>{},
      :status=>'hit')
  end

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

  context '.start' do
    it 'should call register a new game with the service and return a valid game' do
      game.should_receive(:platform_id=)
      api.should_receive(:register)
      api.should_receive(:counter_nuke)

      Battleship.start(game).should eql(game)
    end
  end

  context '.nuke!' do
    it 'should nuke via the platform api, create 2 turns and return the first (the one player created)' do
      api.should_receive(:nuke)
      turns.should_receive(:create!)
      Battleship.should_receive(:receive_nuke!)
      Battleship.nuke!(game, 0).should eql(turn)
    end
    it 'should not call nuke if game is over' do
      game.stub(:over?){true}
      Battleship.should_not_receive(:new)
      Battleship.nuke!(game, 0)
    end
  end

  # context '.recieve_nuke!' do
  #   it 'should nuke a deployed ship and create a turn' do
  #     game.stub_chain(:deployments, :lock_on).and_return({})
  #     Battleship.should_receive(:damage_and_report!)
  #     turns.should_receive(:create!)

  #     Battleship.receive_nuke!(game, 0)
  #   end
  # end

  # context '.damage_and_report!' do
  #   it 'should damage! return "hit" if a ship was passed' do
  #     ship = double('ship')
  #     ship.should_receive(:damage!)
  #     Battleship.damage_and_report!(ship).should eql('hit')
  #   end

  #   it 'should not damage! and return "miss" if falsy was passed' do
  #     ship = false
  #     ship.should_not_receive(:damage!)
  #     Battleship.damage_and_report!(ship).should eql('miss')
  #   end
  # end

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
