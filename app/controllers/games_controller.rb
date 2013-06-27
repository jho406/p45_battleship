class GamesController < ApplicationController
  def create
    game = Battleship.start(params[:game].merge({:model=>Game}))
    game.save!
    head :created
  end

  def show
    game = Game.find(params[:id])
    render game
  end
end
