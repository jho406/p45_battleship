module Api
  module V0
    class DeploymentsController < ApplicationController
      respond_to :json

      def index
        @deployments = current_game.deployments
      end
    end
  end
end