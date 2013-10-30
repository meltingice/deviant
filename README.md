# Deviant

An application exception logger written in Ruby and backed by elasticsearch.

## Features

* Integrates directly into your application with a dead simple API
* Has a web UI built in for analyzing and searching exception data
* Powerful search allows you to quickly find errors for investigating
* Can store arbitrary (searchable) metadata along with the exception, such as: user email, HTTP status, etc
* Sidekiq support for asynchronously updating the search index

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
  # Generic Usage. Simply give Deviant the exception object.
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

### Standalone

Create a config.ru file at the root of your directory.

``` ruby
require 'deviant/web'

# Configure Deviant
Deviant.configure do
  application 'myapp'
  elasticsearch 'http://localhost:9200'
end

run Deviant::Web
```

Now you can run `bundle exec rackup` or use any other Rack-based server of your choice.

### Integration

To integrate Deviant into your Rack application, you'll want to use the URLMap plugin included with Rack. For example, to mount Deviant at `/deviant` alongside your AwesomeServer application:

``` ruby
run Rack::URLMap.new(
  "/" => AwesomeServer::Application,
  "/deviant" => Deviant::Web
)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
