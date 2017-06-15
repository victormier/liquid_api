require './api/schema'

Dotenv.load

class LiquidApi < Roda
  use Rack::JWT::Auth, {secret: ENV['RACK_COOKIE_SECRET'], exclude: %w(/assets), options: { algorithm: 'HS256' }}

  plugin :environments
  self.environment = ENV['RACK_ENV']

  plugin :flash
  plugin :json
  plugin :json_parser
  plugin :render, engine: 'erb'
  plugin :view_options
  plugin :assets
  plugin :multi_route

  require './assets/assets'

  require './api/routes/main.rb'
  (Dir['./api/routes/*.rb'] - ['./api/routes/main.rb']).each{|f| require f}
end
