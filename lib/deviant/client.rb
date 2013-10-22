module Deviant
  class Client
    def initialize(options)
      @options = options
    end

    def store(name, message, data = {})
      entry = {name: name, message: message, date: Time.now}.merge(data)
      return store_async(entry) if @options[:sidekiq][:enabled]

      index { store(entry) }
    end

    def fetch(query, tags = [])
      search do
        query { string query }
        filter :terms, tags: tags if tags.size > 0
        sort { by :date, 'desc' }
      end
    end

    def index(&block)
      Tire.index @options[:name], &block
    end

    def search(&block)
      Tire.search @options[:name], &block
    end

    private

    def store_async(entry)
      DeviantWorker.perform_async(entry)
    end
  end
end