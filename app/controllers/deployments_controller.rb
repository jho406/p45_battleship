class DeploymentsController < ApplicationController
  def index
    render current_game.deployments
  end
end
