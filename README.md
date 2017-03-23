# Microsoft Dynamics API Client
Ruby library for accessing Microsoft Dynamics 365 and 2016 via the Microsoft Web API.

## Installation

Add this line to your application's Gemfile:

    gem 'msdynamics'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install msdynamics

## Usage

#### Access token authentication

To obtain the initial access and refresh tokens you can use [OmniAuth](https://github.com/omniauth/omniauth) in combination with [OmniAuth Azure](https://github.com/KonaTeam/omniauth-azure-oauth2)
```ruby
client = MSDynamics.new({
    hostname: "https://test.crm3.dynamics.com",
    access_token: "djhksjdhu3ye83y",
    refresh_token: "djhksjdhu3ye83y",
    client_id: "absjkdh3ewrwr",
    client_secret: "djskdhak82u3kjhk"
})
```

### Retrieving entity records

Entity types are: `accounts`, `contacts`, `leads` and `opportunities`
```ruby
accounts = client.get_entity_records('accounts')
contacts = client.get_entity_records('contacts')
leads = client.get_entity_records('leads')
opportunities = client.get_entity_records('opportunities')
```

### Modifying or creating entity records

Modifying or creating entity records is currently not supported by this library. Pull or feature requests are welcome!

### OAuth Token Refresh

```ruby
new_token_object = client.refresh_token
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
