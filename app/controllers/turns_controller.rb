class TurnsController < ApplicationController
  def index
    render current_game.turns
  end

  def create
    Battleship.nuke!(params[:turn].merge(:game => current_game))
    head :created
  end
end
