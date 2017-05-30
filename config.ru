# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'tilt/erb'
require 'bundler'
require 'logger'
Bundler.require

# Local config
require "find"

%w{config/initializers api/types api/models middlewares}.each do |load_path|
  Find.find(load_path) { |f|
    require f unless f.match(/\/\..+$/) || File.directory?(f)
  }
end

use Rack::Cors do
  puts ">> CORS CONFIG.RU"
  # allow do
  #   origins 'localhost:3000', '127.0.0.1:3000',
  #           /\Ahttp:\/\/192\.168\.0\.\d{1,3}(:\d+)?\z/
  #           # regular expressions can be used here
  #
  #   resource '/file/list_all/', :headers => 'x-domain-token'
  #   resource '/graphql/*',
  #       :methods => [:get, :post, :delete, :put, :patch, :options, :head],
  #       :headers => 'x-domain-token',
  #       :expose  => ['Some-Custom-Response-Header'],
  #       :max_age => 600
  #       # headers to expose
  # end

  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:post]
  end
end


logger = Logger.new(STDOUT)

logger.level = Logger::DEBUG
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

DB << "SET CLIENT_ENCODING TO 'UTF8';"
DB.loggers << logger if logger

require './roda_graphql'
run RodaGraphql
