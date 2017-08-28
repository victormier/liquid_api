require 'rack/test'
require 'rspec'
require 'dotenv'
require 'pry'
require 'database_cleaner'
require 'shoulda-matchers'
require 'timecop'
require 'webmock/rspec'

Dotenv.load

ENV['RACK_ENV'] = 'test'
OUTER_APP = Rack::Builder.parse_file("./config.ru").first

RSpec.configure do |config|
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  # Make sure database has latest schema on test
  ActiveRecord::Migration.maintain_test_schema!

  # Disable external http requests
  WebMock.disable_net_connect!(allow_localhost: true)

  # rspec-expectations config goes here.
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here.
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Database cleaning
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # Add json header on Rack::Test requests by default
  header "Content-Type", "application/json"

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :active_record
      with.library :active_model
    end
  end

  def json_response
    JSON.parse(last_response.body)
  end
end
