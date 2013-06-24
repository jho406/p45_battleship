class P45
  include HTTParty
  base_uri 'battle.platform45.com'
  debug_output $stdout
  attr_reader :response, :id

  def initialize(args)
    if args[:id]
      @id = args[:id]
    else
      regis = self.register(args)
      @id = regis["id"].to_i
    end
  end

  def register(args)
    @response = self.class.post('/register', {:body=>args.to_json}).parsed_response
  end

  def nuke(coord)
    data = ({:id=>self.id}.merge(coord)).to_json
    @response = self.class.post('/nuke', {:body=>data}).parsed_response
  end
end