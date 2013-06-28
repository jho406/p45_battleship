class Deployment < ActiveRecord::Base
  belongs_to :game
  belongs_to :ship
  #todo: why do i need orientation?
  attr_accessible :ship_id, :orientation, :positions

  before_save :add_lives
  before_validation :expand_positions

  validates :ship_id, :orientation, :positions, :presence => true

  private

  def add_lives
    self.lives = self.ship.length
  end

  def expand_positions
    self.positions = Battleship.expand_pos(
      :position => self.positions.first,
      :length    => self.ship.length #extra query here..
    )
  end

end
