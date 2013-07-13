module Api
  module V0
    class GamesController < ApplicationController
      respond_to :json

      def create
        @game = Game.new(params[:game])
        Battleship.start(@game)
        @game.save!
        render :show, :status => :created, :location => url_for(@game)
      end

      def show
        @game = Game.find(params[:id])
        @turns = @game.turns
      end
    end
  end
end