class HomeController < ApplicationController
  def index
    @ships = Ship.all
    @game = Game.new
    @ships.each do |ship|
      @game.deployments.build(:ship_id => ship.id)
    end
  end
end
