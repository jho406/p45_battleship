require 'battleship/utils'
require 'battleship/actions'

module Battleship
  attr_accessor :game_platform

  include Utils
  include Actions

  extend self
end