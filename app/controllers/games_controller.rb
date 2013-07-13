class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
    @turns = @game.turns
  end
end
