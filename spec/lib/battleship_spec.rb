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
    double('turns', :'new' => {}, :'create!' => turn)
  end

  let(:deployment) do
    double('deployments',
      :positions => [0, 1],
      :lives => 0,
      :'lives=' => nil,
      :damange! => nil
    )
  end

  let(:game) do
    double("game",
      :platform_id => nil,
      :email => 'foo@foo.com',
      :full_name => 'foo',
      :turns => turns,
      :over? => false,
      :lose! => nil,
      :lives => 0,
      :lives= => nil,
      :persisted? => false,
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

  context '.start' do
    it 'should call register a new game with the service and return a game with a built turn' do
      game.should_receive(:platform_id=)
      api.should_receive(:register)
      turns.should_receive(:build)
      Battleship.start(game).should eql(game)
    end

    context 'when the initial api nuke hits a deployment' do
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
      Battleship.should_receive(:receive_nuke!).and_return(turn)
      turns = Battleship.nuke!(game, 0)
      turns.length.should eql(2)
    end

    it 'should not call nuke if game is over' do
      game.stub(:over?){true}
      api.should_not_receive(:nuke)
      Battleship.nuke!(game, 0)
    end

    it 'should return 1 turn and win the game if my next move wins' do
      api.stub(:status){'lost'}
      game.should_receive(:win!)
      turns = Battleship.nuke!(game, 0)
      turns.length.should eql(1)
    end
  end
end
