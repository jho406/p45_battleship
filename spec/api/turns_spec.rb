require "spec_helper"

describe "/turns", :type => :api do
  before do
    Battleship.game_platform = P45
  end

  let(:game) { create :game }
  let(:url)  { "games/#{game.id}/turns" }

  context 'creating a turn' do
    use_vcr_cassette 'p45/nuke'
    it 'should 201 if successful' do
      expect {
        post "#{url}.json", { :position => 0}.to_json, "CONTENT_TYPE" => "application/json"
      }.to change{game.turns.count}.by(2)

      response.status.should eql(201)
      response.body.should eql("{}")
    end
  end

  context 'listing turns' do
    it 'should 200 if successful' do
      get "#{url}.json"
      id = game.turns.first.id
      response.status.should eql(200)
      JSON.parse(response.body).first["id"].should eql(id)
    end
  end
end