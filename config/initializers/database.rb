require 'yaml'
require 'erb'

database_configuration = YAML.load(ERB.new(File.read("db/config.yml")).result)

ActiveRecord::Base.configurations = database_configuration
ActiveRecord::Base.establish_connection(ENV['ENVIRONMENT'])
