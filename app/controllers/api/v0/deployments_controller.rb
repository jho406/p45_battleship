module Api
  module V0
    class DeploymentsController < Api::V0::ApiController
      respond_to :json

      def index
        @deployments = current_game.deployments
      end
    end
  end
end