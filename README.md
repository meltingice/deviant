# Deviant

An application exception logger written in Ruby and backed by elasticsearch. It can be integrated directly into your application or as Rack middleware (coming soon). Search index updates can be performed asynchronously via Sidekiq.

## Installation

Add this line to your application's Gemfile:

    gem 'deviant'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deviant

If you don't have elasticsearch yet, you will need to install it. Luckily it's super easy. If you're running OSX and using homebrew, simply run:

```
brew install elasticsearch
elasticsearch -f -D es.config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
```

## Configuration

``` ruby
Deviant.configure do
  application 'my_application'
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
Deviant.client.fetch(email: 'example@example.com').results

# Directly access Tire search
Deviant.client.search do
  query { string "email:example@example.com" }
end
```

## Deviant Web

Deviant comes with a web UI included that is built with Sinatra. You can either run it standalone or mount it as part of a Rack/Rails app.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
