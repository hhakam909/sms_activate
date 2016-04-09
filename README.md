# SmsActivate

A Ruby wrapper for http://sms-activate.ru API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sms_activate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sms_activate

## Usage

```ruby
  # Initialize a brand new client
  client = SmsActivate::Client.new(ENV['SMS_ACTIVATE_KEY'])

  # Get the balance
  client.get_balance
  # => 42.0

  # Get available services
  client.get_available_services
  # => {"vk_0"=>{"quant"=>"1000", "cost"=>10}, ...}

  # Obtain a number
  client.obtain_number('vk')
  # => #<OpenStruct id=4876647, number="79692572262">

  # It works
  client.get_activation_status(4876647)
  # => #<OpenStruct status=:waiting>

  # Send the sms, then inform the server about it
  client.set_activation_status(4876647, :sms_sent)
  # => #<OpenStruct status=:confirmed>

  # Profit!
  client.get_activation_status(4876647)
  # => #<OpenStruct status=:success, code="878080">
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vladfaust/sms_activate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## ToDo

- [ ] Write some tests
- [ ] Implement forwarding and operators

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

