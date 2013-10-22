# Deviant

An application exception logger written in Ruby and backed by elasticsearch. It can be integrated directly into your application or as Rack middleware (coming soon). Search index updates can be performed asynchronously via Sidekiq.

## Installation

Add this line to your application's Gemfile:

    gem 'deviant'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deviant

## Configuration

``` ruby
Deviant.configure do
  application 'my_application'
  redis Redis.current
  elasticsearch 'http://localhost:9292'
  sidekiq true
end
```

## Logging

``` ruby
begin
  my_broken_code
rescue => e
  # Generic Usage
  Deviant.exception(e)

  # All methods can end with ! to re-raise the exception after logging
  Deviant.exception!(e)

  # Log extra metadata, such as HTTP statuses or User info
  Deviant.exception(e, status: 401, user: user.email)
end
```

## Searching

``` ruby
# Helper method
Deviant.client.fetch("Broken").results.map(&:message)
Deviant.client.fetch("email:example@example.com AND status:404").results

# Directly access Tire search
Deviant.client.search do
  query { string "email:example@example.com" }
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
