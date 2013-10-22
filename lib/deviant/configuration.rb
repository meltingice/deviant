module Deviant
  DEFAULTS = {
    name: nil,
    redis_url: "redis://localhost:9292",
    elasticsearch_url: nil,
    sidekiq: {
      enabled: false,
      configure_server: false,
      configure_client: false
    }
  }

  def self.options
    @options ||= DEFAULTS.dup
  end

  def self.options=(opts)
    @options = opts
  end

  def self.configure(&block)
    class_eval &block
    setup!
  end

  def self.application(name)
    options[:name] = name
  end

  def self.redis(config)
    if config.is_a?(Redis)
      client = config.client
      options[:redis_url] = "#{client.scheme}://#{client.host}:#{client.port}"
    else
      options[:redis_url] = config
    end
  end

  def self.elasticsearch(url)
    options[:elasticsearch_url] = url
  end

  def self.sidekiq(enabled, opts={})
    options[:sidekiq][:enabled] = enabled
    options[:sidekiq][:configure_server] = opts[:configure_server] || false
    options[:sidekiq][:configure_client] = opts[:configure_client] || false
  end

  private

  # A lot of 3rd party libraries are singletons, so we want to make
  # sure we don't blow away the main application's config.
  def self.setup!
    @client = nil

    if options[:sidekiq][:enabled]
      if options[:sidekiq][:configure_client]
        Sidekiq.configure_client do |config|
          config.redis = {
            namespace: options[:name],
            url: options[:redis_url]
          }
        end
      end

      if options[:sidekiq][:configure_server]
        Sidekiq.configure_server do |config|
          config.redis = {
            namespace: options[:name],
            url: options[:redis_url]
          }
        end
      end
    end

    if options[:elasticsearch_url]
      Tire.configure do
        url Deviant.options[:elasticsearch_url]
      end
    end
  end
end