require 'set'

class Game < ActiveRecord::Base
  has_many :deployments
  has_many :turns
  has_many :ships, :through => :deployments

  attr_accessible :email, :full_name,
    :p45_id, :p45_response,
    :deployments_attributes, :turns_attributes

  accepts_nested_attributes_for :deployments, :turns

  validates :email, :full_name, :p45_id, :p45_response, :presence => true
  validates :email,
    :format => { :with=> /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }

  validates :deployments,
    :presence => true,
    :length => {
      :is=>Battleship::SHIPS.length,
      :message=> "All ships need to be deployed"}
  validates :turns, :presence => true

  validate :ships_must_exist_and_be_unique, :positions_must_not_collide

  private


  def ships_must_exist_and_be_unique
    id_set = self.deployments.map(&:ship_id).to_set
    ##todo: inject the ship model?
    unless Battleship.ship_ids.to_set == id_set
      errors.add(:deployments_attributes, "ship ids are not valid")
    end
  end

  def positions_must_not_collide
    all_positions = deployments.inject([]) do |memo, ship|
      # ship.expand_positions
      memo += ship.positions
    end

    collision = !all_positions.group_by { |pos| pos }.select { |k, v| v.size > 1 }.empty?
    errors.add(:deployment_positions, "ships overlap") if collision
  end
end
