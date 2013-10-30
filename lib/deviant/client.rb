module Deviant
  class Client
    def initialize(options)
      @options = options
    end

    def store(name, message, data = {})
      entry = {name: name, message: message, date: Time.now, metadata: data}
      return store_async(entry) if @options[:sidekiq]

      index { store(entry) }
    end

    def fetch(query)
      query = build_query(query)
      search do
        query { string query }
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

    def build_query(query)
      if query.is_a?(Hash)
        return query.to_a.map { |item|
          "#{item[0]}:#{item[1]}"
        }.join(' AND ')
      elsif query.is_a?(Array)
        query.join(' AND ')
      else
        query
      end
    end
  end
end