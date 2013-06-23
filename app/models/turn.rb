class Turn < ActiveRecord::Base
  belongs_to :game

  attr_accessible :p45_response, :position, :cell_x, :cell_y
end
