# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'tilt/erb'
require 'bundler'
require 'logger'
require 'dotenv'
Bundler.require
Dotenv.load

# Require files
require "find"
%w{config/initializers api/types api/models middlewares lib api/forms}.each do |load_path|
  Find.find(load_path) { |f|
    require f unless f.match(/\/\..+$/) || File.directory?(f)
  }
end

# Setup logging
if ENV['RACK_ENV'] == "development"
  logger = Logger.new(STDOUT)
  logger.level = Logger::DEBUG
elsif ENV['RACK_ENV'] == "production"
  Logger.class_eval { alias :write :'<<' }
  logger_file = ::File.new(::File.join(::File.dirname(::File.expand_path(__FILE__)),'..','log','production.log'),"a+")
  logger_file.sync = true
  logger = ::Logger.new(logger_file)
else
  logger = Logger.new(STDOUT)
  logger.level = Logger::WARN
end
logger.formatter = proc do |severity, datetime, progname, msg|
  date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
  if severity == "INFO"
    "[#{date_format}] #{severity}  (#{progname}): #{msg}\n".blue
  elsif severity == "WARN"
    "[#{date_format}] #{severity}  (#{progname}): #{msg}\n".orange
  else
    "[#{date_format}] #{severity} (#{progname}): #{msg}\n".red
  end
end
ActiveRecord::Base.logger = logger if logger

# Setup CORS
use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:post]
  end
end

require './liquid_api'
run LiquidApi
