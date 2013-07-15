class Turn < ActiveRecord::Base
  belongs_to :game

  attr_accessible :position, :attacked, :status

  validates :position, :presence => true
  validates :position, :uniqueness => { :scope => [:game_id, :attacked]}
end
