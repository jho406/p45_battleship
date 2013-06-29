class Turn < ActiveRecord::Base
  belongs_to :game

  attr_accessible :position, :attacked

  validates :position, :presence => true
end
