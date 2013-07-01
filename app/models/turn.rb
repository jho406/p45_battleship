class Turn < ActiveRecord::Base
  belongs_to :game

  attr_accessible :position, :attacked, :status

  validates :position, :presence => true
end
