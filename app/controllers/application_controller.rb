class ApplicationController < ActionController::Base
  protect_from_forgery
  # rescue_from Exception, :with => :api_error

  def api_error
    render :nothing => true, :status => 404
  end

  def current_game
    return nil unless params[:game_id]
    @game ||= Game.find(params[:game_id])
  end
end
