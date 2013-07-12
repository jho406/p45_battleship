require "spec_helper"

describe "/turns", :type => :api do
  let(:game) { create :game }
  let(:url)  { "games/#{game.id}/turns" }

  context 'creating a turn' do
    it 'should 201 if successful' do
      expect {
        post "#{url}.json", { :turn => {:position => 0} }.to_json,
          "CONTENT_TYPE" => "application/json"

        response.status.should eql(201)
        response.body.should eql("{}")
      }.to change{game.turns.count}.by(2)
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