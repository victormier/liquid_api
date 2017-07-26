require "find"
Dotenv.load

class LiquidApi < Roda
  # Require files
  require './api/exceptions'
  %w{config/initializers lib api/types api/mutations api/models middlewares api/forms api/services}.each do |load_path|
    Find.find(load_path) { |f|
      require f unless f.match(/\/\..+$/) || File.directory?(f)
    }
  end
  require './api/schema'

  use PassAuthToken if ENV['RACK_ENV'] == "development"
  use Rack::JWT::Auth, {secret: ENV['RACK_JWT_SECRET'], exclude: %w(/assets /login /users /users/confirm_email), options: { algorithm: 'HS256' }}

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
