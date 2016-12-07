require 'uri'
require 'net/http'
require 'hashie'
require 'json'

# Public: Various methods for accessing MS Dynamics.
class MSDynamics

  # Public: Initialize a MS Dynamics client instance.
  #
  # config - A configuration object.
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

  # Public: Gets all the records for a given MS Dynamics entity.
  #
  # entity_name  - 'accounts', 'leads', 'opportunities' or 'contacts'.
  #
  # Examples
  #
  #   get_entity_records('accounts')
  #   # => {
  #        "@odata.context": "---",
  #        "value": [
  #          {
  #            "@odata.etag": "W/\"640532\"",
  #            "name": "A. Datum",
  #            "emailaddress1": "vlauriant@adatum.com",
  #            "telephone1": "+86-23-4444-0100",
  #            "int_twitter": null,
  #            "int_facebook": null,
  #            "accountid": "475b158c-541c-e511-80d3-3863bb347ba8"
  #          }
  #        ]
  #   }
  #
  # Returns an object with all records for the given entity.
  def get_entity_records(entity_name="")
      # Returns all records that belong to a specific entity.
      url = URI("#{@endpoint}#{entity_name}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request["Authorization"] = "Bearer #{@access_token}"
      response = http.request(request)
      # Return the array of records
      Hashie::Mash.new(JSON.parse(response.body)).value
  end

end
