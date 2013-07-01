class GamesController < ApplicationController
  def create
    game = Battleship.start(params[:game].merge({:model=>Game}))
    game.save!
    render :json=>game.to_json, :status => :created, :location => url_for(game)
  end

  def show
    @game = Game.find(params[:id])
    @turns = @game.turns
  end
end
