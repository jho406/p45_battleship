class TurnsController < ApplicationController
  respond_to :json

  def index
    @turns = current_game.turns
    @game = current_game
  end

  def create
    @turn = Battleship.nuke!(current_game, params[:turn][:position])

    #backbone expects a response in the body, since a turn get created
    #from the backend also, we have no need to return something
    #instead we have to ping index. todo: make this more efficient by returning
    #the entire index instead of black json
    if current_game.over?
      status = 400
    else
      status = 201
    end

    render :show, :status=> status
  end
end