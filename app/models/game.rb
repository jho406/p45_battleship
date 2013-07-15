require 'set'
#Game represents a board. Business logic is kept to a minimal
#with the exception of a few helper classes. See lib/Battleship
#for the bulk of the logic.

#Hopefully with minimal massaging, I can reuse this for say..
#Checkers or anything else with simple collision rules.
class Game < ActiveRecord::Base
  has_many :deployments
  has_many :turns
  has_many :ships, :through => :deployments

  attr_accessible :email, :full_name,
    :platform_id,
    :deployments_attributes, :turns_attributes

  accepts_nested_attributes_for :deployments, :turns

  validates :email, :full_name, :platform_id, :presence => true
  validates :email,
    :format => { :with=> /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }

  validates :deployments,
    :presence => true,
    :length => {
      :is=>Battleship::SHIPS.length,
      :message=> "All ships need to be deployed"}
  validates :turns, :presence => true

  validate :ships_must_exist_and_be_unique, :positions_must_not_collide

  before_create :set_initial_lives_counter

  def over?
    self.over
  end

  def lose!
    self.won = false
    self.over = true
    self.save(:validate => false)
  end

  def win!
    self.won = true
    self.over = true
    self.save(:validate => false)
  end

  #Also holds game logic of when the game is over,
  #but is applicable to many games, so i leave this here.
  def decrement_life_cache!
    return if self.over?
    self.decrement!(:lives)
    self.lose! if self.lives <=0
    return self
  end

  private

  def set_initial_lives_counter
    self.lives ||= 0 #incase we start out with a negative, an initial nuke or move.
    self.lives += Ship.sum(:length)
  end

  def ships_must_exist_and_be_unique
    id_set = self.deployments.map(&:ship_id).to_set
    unless Ship.pluck(:id).to_set == id_set
      errors.add(:deployments_attributes, "ship ids are not valid")
    end
  end

  def positions_must_not_collide
    all_positions = deployments.inject([]) do |memo, ship|
      ship.reset_positions
      memo += ship.positions
    end

    if Battleship.collision?(all_positions)
      errors.add(:deployment_positions, "ships overlap")
    end
  end
end
