class P45
  include HTTParty
  base_uri 'battle.platform45.com'
  debug_output $stdout
  attr_reader :response, :id

  def initialize(args)
    if args[:id]
      @id = args[:id]
    else
      @email = args[:email]
      @name = args[:name]
    end
  end

  def register
    @response = self.class.post('/register',
      {:body=>
        {:email=>@email, :name=>@name}.to_json
      }
    ).parsed_response

    raise HTTParty::ResponseError, "error returned" if @response['error']
    @id = self.response["id"].to_i
    return self
  end

  def nuke(coord)
    return nil unless self.id
    data = ({:id=>self.id}.merge(coord)).to_json
    @response = self.class.post('/nuke', {:body=>data}).parsed_response
    raise HTTParty::ResponseError, "error returned" if @response['error']
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