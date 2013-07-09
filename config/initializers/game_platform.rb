if Rails.env.production?
  Battleship.game_platform = P45
elsif Rails.env.development? || Rails.env.test?
  Battleship.game_platform = MockPlatform
end
