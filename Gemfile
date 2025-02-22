source 'https://rubygems.org'

ruby '2.3.4'

group :development do
  gem 'rake'
end

gem 'puma'
gem 'roda'
gem 'tilt'
gem 'dotenv'

# Graphql
gem 'graphql'

# Database Stack
gem 'pg'
gem 'colorize'

# Models/ORM
gem 'activerecord'
gem 'active_record_migrations' #, "~> 5.0.2.1"
gem 'dry-validation'
gem 'reform'

# Security
gem 'rack-protection'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-jwt'

# Email
gem 'mail'

# Background jobs
gem 'sidekiq'

# Utilities
gem 'racksh'
gem 'bcrypt'
gem 'rest-client'
gem 'money'
gem 'rollbar'
gem 'mixpanel-ruby'

group :test, :development do
  gem 'pry'
end

# Testing
group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'database_cleaner'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'master'
  gem 'timecop'
  gem 'webmock'
  gem 'factory_girl'
end
