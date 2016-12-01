class MSDynamics

  def initialize(config={hostname: nil, access_token: nil})
    # Validate the input.
    raise RuntimeError.new("hostname and access_token are required") if config[:hostname].nil?  && config[:access_token].nil?
    # Set up the variables
    @access_token = config[:access_token]
    @hostname = config[:hostname]
    @endpoint = "https://#{@hostname}/api/data/v8.0/"
  end

  def get_entity_records(entity_name="")
    puts entity_name
    puts @access_token
    puts @hostname
    puts @endpoint
  end

end
