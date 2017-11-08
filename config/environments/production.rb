LiquidApi.configure do |config|
  config.default_client_host = ENV['DEFAULT_CLIENT_HOST']
  config.default_api_host = ENV['DEFAULT_API_HOST']
end
