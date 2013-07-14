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

  let(:deployment) do
    double('deployments',
      :positions=>[0, 1],
      :lives=>0
    )
  end

  let(:game) do
    double("game",
      :platform_id => nil,
      :prepared?  => true,
      :email => 'foo@foo.com',
      :full_name => 'foo',
      :turns => turns,
      :over? => false,
      :lose! => nil,
      :lives => 0,
      :deployments => [deployment]
    )
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
      Battleship.should_receive(:receive_initial_nuke)
      Battleship.start(game).should eql(game)
    end

    context 'when the initial api nuke hits' do
      before(:each){game.stub(:persisted? => false)}
      it 'should decrement game and deployment lives' do
        game.should_receive(:platform_id=)
        game.should_receive(:lives=).with(-1)
        deployment.should_receive(:lives=).with(-1)
        turns.should_receive(:build)
        Battleship.start(game)
      end
    end
  end

  context '.nuke!' do
    it 'should nuke via the platform api, create and return 2 turns' do
      api.should_receive(:nuke)
      turns.should_receive(:create!)
      Battleship.should_receive(:receive_nuke!)
      turns = Battleship.nuke!(game, 0)
      turns.length.should eql(2)
      turns.first.should eql(turn)
    end

    it 'should not call nuke if game is over' do
      game.stub(:over?){true}
      Battleship.should_not_receive(:new)
      Battleship.nuke!(game, 0)
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
