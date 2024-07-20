# Flexipass

This Ruby gem provides an integration with the Flexipass door lock system, allowing you to easily interact with Flexipass APIs.

## Installation

Add this line to your application's Gemfile:

`gem 'flexipass'`

And then execute: 

`$ bundle`

Or install it yourself as:

`$ gem install flexipass`

## Configuration
Before using the Flexipass gem, you need to configure it with your credentials and preferences. You can do this in an initializer or before your application starts:
```
Flexipass.configure do |config|
  config.username = 'your_username'
  config.password = 'your_password'
  config.company_token = 'your_company_token'
  config.environment = :development # or :production
  config.enable_logging = true # optional, defaults to false
end
```
Configuration Options

* `username`: Your Flexipass account username (required)
* `password`: Your Flexipass account password (required)
* `company_token`: Your company's unique token (required)
* `environment`: Either :development or :production (defaults to :development)
* `enable_logging`: Set to true to enable logging (optional, defaults to false)

## Usage
After configuring the gem, you can create a client and use it to interact with the Flexipass API:
```
client = Flexipass::Client.new
```

#### List all doors
```
door = client.door
response = door.list
```

#### Create a mobile key

```
mobile_key = client.mobile_key
params = {
  Name: "John",
  Surname: "Doe",
  Mail: "john.doe@example.com",
  Door: "101", // use door.list operation to find door
  Checkin_date: "2023-07-01",
  Checkin_time: "14:00:00",
  Checkout_date: "2023-07-05",
  Checkout_time: "11:00:00",
  MobileKeyType: 0
}
response = mobile_key.create(params)
```

#### Update a mobile key

```
mobile_key = client.mobile_key
mobile_key_id = "123456"
update_params = {
  # Include parameters to update
}
response = mobile_key.update(mobile_key_id, update_params)
```

#### Delete a mobile key 
```
mobile_key = client.mobile_key
mobile_key_id = "123456"
response = mobile_key.delete(mobile_key_id)
```

#### List all keys against a door
```
mobile_key = client.mobile_key
door = "101"
list_params = {
  StartDate: "20230701T1400",
  EndDate: "20230705T1100"
}
response = mobile_key.list(door, list_params)
```

#### Fetch company details
```
company = client.company
response = company.details
```

#### Fetch company permissions
```
company = client.company
response = company.permissions
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kellenkyros/flexipass. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/flexipass/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Flexipass project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/flexipass/blob/main/CODE_OF_CONDUCT.md).
