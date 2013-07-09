class MockPlatform
  CACHE = ActiveSupport::Cache::FileStore.new('tmp/mock_platform')

  MOVES = [
    {'x' => 0, 'y' => 0},
    {'x' => 0, 'y' => 1, 'status' => 'hit'},
    {'x' => 0, 'y' => 2, 'status' => 'hit'},
    {'x' => 0, 'y' => 3, 'status' => 'hit'},
    {'x' => 0, 'y' => 4, 'status' => 'hit'},
    {'x' => 0, 'y' => 5, 'status' => 'hit'},
    {'x' => 0, 'y' => 6, 'status' => 'hit'},
    {'x' => 0, 'y' => 7, 'status' => 'hit'},
    {'x' => 0, 'y' => 8, 'status' => 'hit'},
    {'x' => 0, 'y' => 9, 'status' => 'hit'},
    {'x' => 1, 'y' => 0, 'status' => 'hit'},
    {'x' => 1, 'y' => 1, 'status' => 'hit'},
    {'x' => 1, 'y' => 2, 'status' => 'hit'},
    {'x' => 1, 'y' => 3, 'status' => 'hit'},
    {'x' => 1, 'y' => 4, 'status' => 'hit'},
    {'x' => 1, 'y' => 5, 'status' => 'hit'},
    {'x' => 1, 'y' => 6, 'status' => 'hit'},
    {'x' => 1, 'y' => 7, 'status' => 'hit'},
    {'x' => 1, 'y' => 8, 'status' => 'hit'},
    {'error' => 'The game with id=2425 is already over',
     'game_status'=>'lost',
     'prize'=>"Congratulations! Please zip and email your code to neil+priority@platform45.com"}
  ]

  attr_reader :response, :id

  def initialize(args)
    if args[:id]
      @id = args[:id]
      self.step = 0
    else
      @email = args[:email]
      @name = args[:name]
    end
  end

  def step
    CACHE.read(self.id)
  end

  def step=(num)
    CACHE.write(self.id, num)
  end

  def step!
    self.step = self.step + 1 unless self.step == MOVES.size-1
    return MOVES[self.step]
  end

  def register
    @id = rand(0..1000)
    self.step = -1
    @response = self.step!
    return self
  end

  def nuke(coord)
    return nil unless self.id
    @response = step!
    return self
  end

  def counter_nuke
    return nil unless @response
    {:x => @response['x'], :y => @response['y']}
  end

  def status
    return nil unless @response
    @response['game_status'] || @response['status'] || nil
  end

  def prize
    return nil unless @response
    @response['prize']
  end
end