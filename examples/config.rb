require 'deviant'

Deviant.configure do
  application 'myapp'
  elasticsearch 'http://localhost:9200'
end
