require 'deviant'

Deviant.configure do
  application 'testing'
  elasticsearch 'http://localhost:9200'
  sidekiq true
end
