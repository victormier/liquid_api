require 'mail'

Mail.defaults do
  # delivery_method Mail::LoggerDelivery
  case ENV['RACK_ENV']
  when "development"
    delivery_method :smtp, address: ENV['MAILCATCHER_URL'], port: 1025
  when "test"
    delivery_method :test
  when "production"
    delivery_method :smtp, {
      :address => 'smtp.sendgrid.net',
      :port => 587,
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :tls => true,
      :domain => 'helloliquid.com'
    }
  end
end
