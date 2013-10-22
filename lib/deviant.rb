require "tire"
require "sidekiq"
require "yajl/json_gem"

require "deviant/configuration"
require "deviant/client"
require "deviant/log"
require "deviant/worker"
require "deviant/version"

module Deviant
  def self.client
    @client ||= Client.new(options)
  end
end
