class Turn < ActiveRecord::Base
  belongs_to :game

  attr_accessible :p45_response, :position

  validates :p45_response, :position, :presence => true
end
