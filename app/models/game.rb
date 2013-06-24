require 'set'

class Game < ActiveRecord::Base
  has_many :deployments
  has_many :turns
  has_many :ships, :through => :deployments

  attr_accessible :email, :full_name, :p45_id, :p45_response

  accepts_nested_attributes_for :deployments, :turns

  validates :email, :full_name, :p45_id, :p45_response, :presence => true
  validates :deployment_attributes,
    :presence => true,
    :length => {:is=>Battleship::SHIPS.length}
  validate :deployment_ids_must_equal

  private

  def deployment_ids_must_equal
    id_set = self.deployment_attributes.map{|ship|ship.ship_id}.to_set
    if Battleship.ship_ids.to_set != id_set
      errors.add(:deployment_attributes, "ship ids are not valid")
    end
  end
end
