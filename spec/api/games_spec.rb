require "spec_helper"

describe "/games", :type => :api do
  let(:game) {  create :game }
  let(:url) {'/games'}

  context 'creating a game' do
    use_vcr_cassette 'p45/register'
    it 'should 201 if successful' do
      Battleship.game_platform = P45
      post "#{url}.json", { :game=> {
        :email => 'test@test.com',
        :full_name => 'test',
        :deployments_attributes => game.deployments.select([:ship_id, :positions, :orientation]).map(&:serializable_hash)
      }}.to_json, "CONTENT_TYPE" => "application/json"

      response.status.should eql(201)
      response.headers["Location"].should_not be_nil
      JSON.parse(response.body)["id"].should eql(Game.last.id)
    end
  end
end