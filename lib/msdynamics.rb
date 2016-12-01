require 'uri'
require 'net/http'
require 'hashie'
require 'json'

class MSDynamics

  def initialize(config={hostname: nil, access_token: nil})
    # Validate the input.
    if config[:hostname].nil?  && config[:access_token].nil?
      raise RuntimeError.new("hostname and access_token are required")
    end
    # Set up the variables
    @access_token = config[:access_token]
    @hostname = config[:hostname]
    @endpoint = "https://#{@hostname}/api/data/v8.0/"
  end

  def get_entity_records(entity_name="")
      # Returns all records that belong to a specific entity.
      url = URI("#{@endpoint}#{entity_name}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request["Authorization"] = "Bearer #{@access_token}"
      response = http.request(request)
      # Return an object that represents the response
      Hashie::Mash.new(JSON.parse(response.body))
  end

end
