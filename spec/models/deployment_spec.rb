require 'spec_helper'

describe Deployment do

  it { should belong_to(:game) }
  it { should belong_to(:ship) }

  it { should validate_presence_of :ship_id }
  it { should validate_presence_of :orientation }
  it { should validate_presence_of :positions }

  context 'before saving' do
    let(:game) {create :game}
    let(:deployed) {game.deployments.first}

    it 'should add_lives' do
      deployed.stub_chain(:self, :ship, :length).and_return(10)
      deployed.should_receive(:add_lives)
      deployed.run_callbacks(:create)
    end
  end

  context '#reset_positions' do
    let!(:game) {create :game}
    let!(:deployed) {game.deployments.first}
    let(:battleship){double('battleship')}

    it 'should reset its positions array based off the first element ' do
      stub_const("Battleship", battleship)
      battleship.should_receive(:expand_pos)
      deployed.reset_positions
    end
  end

  context '#damage!' do
    let(:game) {create :game}
    let(:deployed) {game.deployments.first}

    it "should decrement lives and the cache to game" do
      expect{deployed.damage!}.to change{deployed.lives}.by(-1)
      expect{game.reload}.to change{game.lives}.by(-1)
    end
  end

  context '.lock_on' do
    let(:game) {create :game}
    let(:deployments) {game.deployments}

    it 'should return the first deployment at position' do
      deployments.lock_on(0).should eql(deployments.first)
    end
  end
end
