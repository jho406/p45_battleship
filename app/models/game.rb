class Game < ActiveRecord::Base
  has_many :deployments
  has_many :turns
  has_many :ships, :through => :deployments

  attr_accessible :email, :full_name, :p45_id, :p45_response

  accepts_nested_attributes_for :deployments, :turns

  validates :email, :full_name, :p45_id, :p45_response, :presence => true
end
