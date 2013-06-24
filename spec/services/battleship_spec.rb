require 'spec_helper'

describe Battleship do
  before(:each) do
    api = double("P45")
    api.stub(:response) do
      {:id=>0, x: 0, y: 0}
    end
    api.stub(:id) do
      0
    end
    api.stub(:nuke)

    stub_const('Battleship::P45', double())
    Battleship::P45.stub('new'){api}
  end

  context '#seed' do
    it 'should populate the the appropriate model' do
      model = double('game')
      model.should_receive(:create).with(Battleship::SHIPS)
      Battleship.seed(model)
    end
  end

  context '#ship_ids' do
    it 'should return a list of current ids' do
      pending 'its just one line...'
    end
  end

  context '#start' do
    it 'should call register a new game with the service and return a valid game' do
      game = double("Game")
      game.stub(:new){"started"}

      args = {
        :email=>"test@test.com",
        :name=> "test",
        :model=> game,
        :deployment_attributes=>[
          {:ship_id=>1, :position=>0,  :orientation=>"horizontal"},
          {:ship_id=>2, :position=>10, :orientation=>"horizontal"}
        ]
      }

      game.should_receive(:new)
      Battleship::P45.should_receive(:new)
      Battleship.start(args).should == "started"
    end
  end

  context '#nuke' do
    it 'should nuke via P45 and create a turn' do
      game = double("Game")
      turn = double("Turn")
      turn.stub('create')
      game.stub('turn') {turn}
      game.stub('id') {0}

      turn.should_receive(:create)
      Battleship.nuke(game, 0)
    end
  end

  context '#coord_to_pos' do
    it 'should convert a hash of coords into a index' do
      Battleship.coord_to_pos({:x=>1, :y=>2}).should eq(12)
    end

    it 'should throw an error if the coord is beyond the limits of the boardsize' do
      expect{Battleship.coord_to_pos({:x=>1, :y=>11})}.to raise_error(ArgumentError)
    end
  end

  context '#pos_to_coord' do
    it 'should convert an index into a hash of coordinates' do
      Battleship.pos_to_coord(99).should eql({:x=>9, :y=>9})
    end

    it 'should throw an error if the index is beyond the limits of the boardsize' do
      expect{Battleship.pos_to_coord(100).should}.to raise_error(ArgumentError)
    end
  end

  context '#transform_coord' do
    it 'should extract coordinates from a response' do
      coord = {:x=>1, :y=>2}
      response = {:foo=>'bar'}.merge(coord)
      Battleship.transform_coord(response).should eql(coord)
    end
  end

  context '#expand_pos' do
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
      expect{Battleship.expand_pos(args)}.to raise_error(ArgumentError)
    end

  end

end
