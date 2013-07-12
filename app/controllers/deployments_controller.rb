class DeploymentsController < ApplicationController
  respond_to :json

  def index
    @deployments = current_game.deployments
  end
end
