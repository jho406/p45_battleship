#Deployment represents a ship deployed on a board

class Deployment < ActiveRecord::Base

  belongs_to :game
  belongs_to :ship
  attr_accessible :ship_id, :orientation, :positions, :lives

  before_create :add_lives

  validates :ship_id, :orientation, :positions, :presence => true
  validate :all_positions_are_fixnum

  #returns a currently deployed ship based on a position
  def self.lock_on(position)
    where.any(:positions=>position).limit(1).first
  end

  #damages by reducing the life of itself and the parent.
  def damage!
    self.decrement!(:lives)
    self.game.decrement_life_cache!
    return self
  end

  #resets the positions array based off the first pos.
  #This is to ensure correct and valid ship positionings.
  def reset_positions
    self.positions = Battleship.expand_pos(
      :position => self.positions.first,
      :length    => self.ship.length, #extra query here..
      :orientation => self.orientation
    )
  end

  private

  def add_lives
    self.lives||=0
    self.lives+= self.ship.length
  end

  def all_positions_are_fixnum
    return if self.positions.to_a.all? {|i| i.is_a? Fixnum }
    errors.add(:positions, 'all positions must be a number')
  end

end
