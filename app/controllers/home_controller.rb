class HomeController < ApplicationController
  def index
    #convience feature for development. Easy switch for platforms
    if Rails.env.development?
      Battleship.game_platform = P45 if params[:platform] == 'p45'
      Battleship.game_platform = MockPlatform if params[:platform].nil?
    end

    @ships = Ship.all
    @game = Game.new
    @ships.each do |ship|
      @game.deployments.build(:ship_id => ship.id)
    end
  end
end
