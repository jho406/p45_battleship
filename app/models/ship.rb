class Ship < ActiveRecord::Base
  has_many :deployments
  has_many :games, :through => :deployments

  attr_accessible :length, :name
end
