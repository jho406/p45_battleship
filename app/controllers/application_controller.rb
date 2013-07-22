class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_game
    return nil unless params[:game_id]
    @game ||= Game.find(params[:game_id])
  end
end
