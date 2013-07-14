require 'spec_helper'

describe Game do

  it { should have_many(:deployments) }
  it { should have_many(:turns) }
  it { should have_many(:ships) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:platform_id) }

  it { should validate_presence_of(:deployments) }
  it { should validate_presence_of(:turns) }

  it { should accept_nested_attributes_for(:turns) }
  it { should accept_nested_attributes_for(:deployments) }

  context 'before creating' do
    let(:game){ build :game }
    it 'should validate ship_must_exist_and_be_unique' do
      game.should_receive(:ships_must_exist_and_be_unique)
      game.valid?
    end

    it 'should validate positions_must_not_collide' do
      game.should_receive(:positions_must_not_collide)
      game.valid?
    end

    it 'should set_initial_lives_counter' do
      game.should_receive(:set_initial_lives_counter)
      game.save
    end
  end

  context '#over?' do
    let(:game) { build :game, :over => true }
    it 'should just delegate to over' do
      game.over?.should eql(game.over)
    end
  end

  context '#lose!' do
    let(:game) { create :game }
    it 'should set won to false and over to true' do
      game.won = false
      expect{game.win!}.to change{game.won}.to(true)
      game.over.should be_true
    end
  end

  context '#win!' do
    let(:game) { create :game }
    it 'should set won to false and over to true' do
      game.won = true
      expect{game.lose!}.to change{game.won}.to(false)
      game.over.should be_true
    end
  end

  context '#decrement_life_cache!' do
    it 'should decrement lives if game is not over' do
      game = create :game, :over=>false
      expect{ game.decrement_life_cache! }.to change{ game.lives }
    end

    it 'should not decrement lives if game is over' do
      game = create :game, :over=>true
      expect{ game.decrement_life_cache! }.to_not change{ game.lives }
    end

    it 'should set over to false if game is over' do
      game = create :game
      game.update_attribute(:lives, 1)
      game.decrement_life_cache!
      game.over.should eql(true)
    end
  end
end
