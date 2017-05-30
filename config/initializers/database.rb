require "yaml"
require "dotenv"
Dotenv.load
settings = YAML::load_file("config/db.yml")
# Sequel Configuration
DB = Sequel.connect(settings[ENV['ENVIRONMENT']])
