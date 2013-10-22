require 'deviant'

Deviant.configure do
  application 'testing'
  elasticsearch 'http://localhost:9200'
  redis 'redis://localhost:6379'
  sidekiq true
end
