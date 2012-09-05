ENV["RAILS_ENV"] = 'test'

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start do
    add_group "Models", "app/models"
    add_group "Controllers", "app/controllers"
  end
end

require 'rubygems'
require 'spork'
require 'capybara/rspec'
require 'capybara-webkit'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'authlogic/test_case'
  require 'factory_girl'
  require 'shoulda/matchers'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  Capybara.javascript_driver = :webkit

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    config.include CustomMatchers
    config.include Webrat::Matchers
    config.include EtmAuthHelper
    config.include Authlogic::TestCase
    config.include Capybara::DSL
    config.include Capybara::RSpecMatchers

    Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
end
