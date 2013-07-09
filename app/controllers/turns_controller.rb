class TurnsController < ApplicationController

  def index
    @turns = current_game.turns
    @game = current_game
  end

  def create
    # puts params
    # debugger
    Battleship.nuke!(current_game, params[:turn][:position])


    #backbone expects a response in the body, since a turn get created
    #from the backend also, we have no need to return something
    #instead we have to ping index. todo: make this more efficient by returning
    #the entire index instead of black json
    if current_game.over?
      status = 400
    else
      status = 201
    end

    render :json=>{}.to_json, :status=> status
  end
end


#todo refactor: i chould just do a single turns game thing..nested turns and stuf...lazy load