require "find"
require 'sidekiq'
require 'tilt/erb'
require 'bundler'
require 'dotenv'

Bundler.require
Dotenv.load

class LiquidApi < Roda
  require './lib/configurable'
  extend LiquidApiUtils::Configurable

  # Require active support extensions
  require 'active_support/core_ext/object/blank'
  require 'active_support/core_ext/date_time/calculations'

  # Require environment config
  environment_config_path = "./config/environments/#{ENV['RACK_ENV']}"
  require environment_config_path if File.exists?("#{environment_config_path}.rb")

  # Require files
  require './api/exceptions'
  %w{config/initializers lib api/types api/mutations api/models middlewares api/forms api/services api/workers}.each do |load_path|
    Find.find("./#{load_path}") { |f|
      require f unless f.match(/\/\..+$/) || File.directory?(f)
    }
  end
  require './api/schema'

  use PassAuthToken if ENV['RACK_ENV'] == "development"
  EXCLUDE_PATHS = %w(
    /assets
    /login
    /users
    /users/confirm_email
    /users/from_reset_password_token
    /users/:id/set_password
    /saltedge_callbacks/success
    /saltedge_callbacks/failure
  )
  use Rack::JWT::Auth, {secret: ENV['RACK_JWT_SECRET'], exclude: EXCLUDE_PATHS, options: { algorithm: 'HS256' }}

  plugin :environments
  self.environment = ENV['RACK_ENV'].to_sym

  plugin :flash
  plugin :json
  plugin :json_parser
  plugin :render, engine: 'erb'
  plugin :view_options
  plugin :assets
  plugin :multi_route
  plugin :symbol_status
  plugin :mailer, content_type: 'text/html'

  require './assets/assets'

  require './api/routes/main.rb'
  (Dir['./api/routes/*.rb'] - ['./api/routes/main.rb']).each{|f| require f}
end
