class TurnsController < ApplicationController

  def index
    @turns = current_game.turns
    @game = current_game
  end

  def create
    Battleship.nuke!(current_game, params[:turn][:position])
    #backbone expects a response in the body, since a turn get created
    #from the backend also, we have no need to return something
    #instead we have to ping index. todo: make this more efficient by returning
    #the entire index instead of black json
    render :json=>{}.to_json, :status=>:created
  end
end
