class DeviantWorker
  include Sidekiq::Worker

  def perform(data)
    Tire.index Deviant.options[:name] do
      store(data)
    end
  end
end