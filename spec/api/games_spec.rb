require "spec_helper"

describe "/games", :type => :api do
  let(:game) {  create :game }
  let(:url) {'/games'}
  let(:deployments_attributes) do
    game.deployments.select(
      [:ship_id, :positions, :orientation]).map(&:serializable_hash)
  end

  context 'creating a game' do
    it 'should 201 if successful' do
      post "#{url}.json", { :game=> {
        :email => 'test@test.com',
        :full_name => 'test',
        :deployments_attributes => deployments_attributes
      }}.to_json, "CONTENT_TYPE" => "application/json"

      response.status.should eql(201)
      response.headers["Location"].should_not be_nil
      JSON.parse(response.body)["id"].should eql(Game.last.id)
    end
  end
end