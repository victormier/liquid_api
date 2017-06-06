# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'tilt/erb'
require 'bundler'
require 'logger'
require 'dotenv'
Bundler.require

# Local config
require "find"

%w{config/initializers api/types api/models middlewares}.each do |load_path|
  Find.find(load_path) { |f|
    require f unless f.match(/\/\..+$/) || File.directory?(f)
  }
end

Dotenv.load

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:post]
  end
end


logger = Logger.new(STDOUT)

if ENV['RACK_ENV'] == "development"
  logger.level = Logger::DEBUG
else
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

require './roda_graphql'
run RodaGraphql
