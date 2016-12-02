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

```ruby
client = MSDynamics.new({hostname: "test.crm3.dynamics.com", access_token: "djhksjdhu3ye83y"})
```

### Retrieve

```ruby
records = client.get_entity_records('accounts')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
