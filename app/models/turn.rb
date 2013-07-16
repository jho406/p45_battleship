#Turn represents a history dump of what happened
#during a game. No logic should belong here.

class Turn < ActiveRecord::Base
  belongs_to :game

  attr_accessible :position, :attacked, :status

  validates :position, :presence => true
end
