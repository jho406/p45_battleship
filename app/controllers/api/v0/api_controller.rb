module Api
  module V0
    class ApiController < ActionController::Base
      respond_to :json

      rescue_from Exception, :with => :api_error

      def api_error
        render :nothing => true, :status => 404
      end

      def current_game
        return nil unless params[:game_id]
        @game ||= Game.find(params[:game_id])
      end
    end
  end
end