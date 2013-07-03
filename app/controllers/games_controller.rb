class GamesController < ApplicationController
  def create
    game = Game.new(params[:game])
    Battleship.start(game)
    game.save!
    #todo: rabl
    render :json=>game.to_json, :status => :created, :location => url_for(game)
  end

  def show
    @game = Game.find(params[:id])
    @turns = @game.turns
  end
end
