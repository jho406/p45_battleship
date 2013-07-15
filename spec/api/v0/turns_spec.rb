require "spec_helper"

describe "/turns", :type => :api do
  let(:game) { create :game }
  let(:url)  { "api/games/#{game.id}/turns" }

  context 'creating a turn' do
    it 'should 201 if successful' do
      expect {
        post "#{url}", { :turn => {:position => 0} }.to_json,
          "CONTENT_TYPE" => "application/json"

        response.status.should eql(201)
        body = JSON.parse(response.body)
        body['position'].should eql(0)
        body['attacked'].should eql(true)

      }.to change{game.turns.count}.by(2)
    end
  end

  context 'listing turns' do
    it 'should 200 if successful' do
      get "#{url}"
      id = game.turns.first.id
      response.status.should eql(200)
      JSON.parse(response.body).first["id"].should eql(id)
    end
  end
end