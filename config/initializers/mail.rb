require 'mail'

Mail.defaults do
  # delivery_method Mail::LoggerDelivery
  case ENV['RACK_ENV']
  when 'development'
    delivery_method :smtp, address: "localhost", port: 1025
  when 'test'
    delivery_method :test
  when 'production'
    # TO DO
  end
end
