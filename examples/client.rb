require 'deviant'

Deviant.configure do
  application 'testing'
  elasticsearch 'http://localhost:9200'
  redis 'redis://localhost:6379'
  sidekiq true
end

Deviant.client.index { delete }
Deviant.exception(StandardError.new("Fail"))
Deviant.exception(StandardError.new("Extra fail"))

