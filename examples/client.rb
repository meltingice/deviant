require_relative './config'

Deviant.client.index { delete }
Deviant.exception(StandardError.new("Fail"), user: 1)
Deviant.exception(StandardError.new("Extra fail"), user: 2)
Deviant.client.index { refresh }