class DeviantWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'deviant'

  def perform(data)
    Tire.index Deviant.options[:name] do
      store(data)
    end
  end
end