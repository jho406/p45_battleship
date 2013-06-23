class Game < ActiveRecord::Base
  has_many :deployments
  has_many :ships, :through => :deployments

  attr_accessible :email, :full_name, :p45_id, :p45_response, :status
end
