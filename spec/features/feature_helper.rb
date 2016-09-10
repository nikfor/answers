require "rails_helper"

RSpec.configure do |config|
  config.include FeatureMacros, type: :feature

  Capybara.javascript_driver = :webkit
  Capybara.default_max_wait_time = 5
  Capybara.server_port = 3000

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
