require 'erb'
require 'sass'
require 'sinatra/base'
require 'sinatra/assetpack'

require 'deviant'
require 'deviant/web_helpers'

module Deviant
  class Web < Sinatra::Base
    include Deviant::WebHelpers
    register Sinatra::AssetPack
    
    set :root, File.expand_path(File.dirname(__FILE__) + "/../../web")
    set :public_folder, -> { "#{root}/assets" }
    set :views, -> { "#{root}/views" }

    Sass.load_paths << "#{root}/assets/stylesheets"

    assets {
      serve "/js",      from: "assets/javascripts"
      serve "/css",     from: "assets/stylesheets"
      serve "/images",  from: "assets/images"

      css :application, [
        "/css/application.css"
      ]

      css_compression :sass
    }

    get '/' do
      erb :dashboard
    end
  end
end