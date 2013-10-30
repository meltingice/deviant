module Deviant
  DEFAULTS = {
    name: nil,
    elasticsearch_url: nil,
    sidekiq: false
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

  def self.elasticsearch(url)
    options[:elasticsearch_url] = url
  end

  def self.sidekiq(enabled)
    options[:sidekiq] = enabled
  end

  private

  # A lot of 3rd party libraries are singletons, so we want to make
  # sure we don't blow away the main application's config.
  def self.setup!
    @client = nil

    if options[:elasticsearch_url]
      Tire.configure do
        url Deviant.options[:elasticsearch_url]
      end
    end
  end
end