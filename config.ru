require 'deviant/web'

# default local configuration
Deviant.configure do
  application 'myapp'
  elasticsearch 'http://localhost:9200'
end

run Deviant::Web