module Api
  module V0
    class TurnsController < ApplicationController
      respond_to :json

      def index
        @turns = current_game.turns
        @game = current_game
      end

      def create
        raise ActiveRecord::RecordNotSaved, 'Game over' if current_game.over?

        @turn = Game.transaction do
          Battleship.nuke!(current_game, params[:turn][:position]).first
        end

        render :show, :status => 201
      end
    end
  end
end