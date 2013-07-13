class Deployment < ActiveRecord::Base
  belongs_to :game
  belongs_to :ship
  attr_accessible :ship_id, :orientation, :positions, :lives

  before_create :add_lives

  validates :ship_id, :orientation, :positions, :presence => true
  validate :all_positions_are_fixnum

  def self.lock_on(position)
    where.any(:positions=>position).limit(1).first
  end

  def damage!
    self.decrement!(:lives)
    self.game.decrement_life_cache!
    return self
  end

  def damage_and_report!
    self.damage! #decrement the ship that got hit careful for less than zero
    return "hit"
  end

  def reset_positions
    self.positions = Battleship.expand_pos(
      :position => self.positions.first,
      :length    => self.ship.length, #extra query here..
      :orientation => self.orientation
    )
  end

  private

  def add_lives
    self.lives = self.ship.length
  end

  def all_positions_are_fixnum
    return if self.positions.to_a.all? {|i| i.is_a? Fixnum }
    errors.add(:positions, 'all positions must be a number')
  end

end
