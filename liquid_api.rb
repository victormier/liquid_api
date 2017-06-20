require './api/schema'

Dotenv.load

class LiquidApi < Roda
  use Rack::JWT::Auth, {secret: ENV['RACK_JWT_SECRET'], exclude: %w(/login), options: { algorithm: 'HS256' }}

  plugin :environments
  self.environment = ENV['RACK_ENV']

  plugin :flash
  plugin :json
  plugin :json_parser
  plugin :render, engine: 'erb'
  plugin :view_options
  plugin :assets
  plugin :multi_route
  plugin :symbol_status

  require './assets/assets'

  require './api/routes/main.rb'
  (Dir['./api/routes/*.rb'] - ['./api/routes/main.rb']).each{|f| require f}
end
