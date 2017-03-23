require 'uri'
require 'net/http'
require 'hashie'
require 'json'

# Public: Various methods for accessing MS Dynamics.
class MSDynamics

  # Public: Initialize a MS Dynamics client instance.
  #
  # config - A configuration object.
  def initialize(config={
      hostname: nil, access_token: nil, refresh_token: nil,
      client_id: nil, client_secret: nil})
    # Validate the input.
    if config[:hostname].nil?  && config[:access_token].nil?
      raise RuntimeError.new("hostname and access_token are required")
    end
    # Set up the variables
    @access_token = config[:access_token]
    @refresh_token = config[:refresh_token]
    @hostname = config[:hostname]
    @client_id = config[:client_id]
    @client_secret = config[:client_secret]
    @endpoint = "#{@hostname}/api/data/v8.0/"
    # Get the authenticated user's information ('WhoAmI')
    # This also validates the access tokens and client secrets.
    # If validation fails, it will raise an exception back to the calling app.
    response = DynamicsHTTPClient.request("#{@endpoint}WhoAmI", @access_token)
    @user_id = JSON.parse(response.body)['UserId']
  end

  # Public: Gets all the records for a given MS Dynamics entity.
  #
  # entity_name  - 'accounts', 'leads', 'opportunities' or 'contacts'.
  #
  # Examples
  #
  #   get_entity_records('accounts')
  #   # => [
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
  #
  # Returns an object with all records for the given entity.
  def get_entity_records(entity_name="")
    # Add a filter so we only get records that belong to the authenticated user.
    filter = "_ownerid_value eq (#{@user_id})"
    request_url = "#{@endpoint}#{entity_name}?$filter=#{filter}"
    # Return the array of records
    response = DynamicsHTTPClient.request(request_url, @access_token)
    Hashie::Mash.new(JSON.parse(response.body)).value
  end

  def refresh_token()
    response = DynamicsHTTPClient.refresh_token(
      "https://login.windows.net/common/oauth2/token", @refresh_token,
      @client_id, @client_secret, @hostname)
    token_object = Hashie::Mash.new(JSON.parse(response.body))
    @access_token = token_object.access_token
    @refresh_token = token_object.refresh_token
    token_object
  end

end

# Private: Methods for making HTTP requests to the Dynamics Web API.
class DynamicsHTTPClient
  # Sends a HTTP request.(GET)
  def self.request(url="", access_token="")
      uri = URI(URI.encode(url))
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{access_token}"
      response = http.request(request)
      if response.code != '200'
        if response.code == '401'
          # Ughhh! MS Dynamics puts the 401 error messages in the body!
          error_message = response.body
        else
          error_message = JSON.parse(response.body)['error']['message']
        end
        raise RuntimeError.new(error_message)
      end
      response
  end

  # Allows refreshing an oAuth access token.
  def self.refresh_token(url="", refresh_token="",
                         client_id="", client_secret="", resource="")
    params = {
      'refresh_token' => refresh_token,
      'client_id'     => client_id,
      'client_secret' => client_secret,
      'grant_type'    => 'refresh_token',
      'resource'      => resource
    }
    uri = URI(url)
    Net::HTTP::post_form(uri, params)
  end
end
