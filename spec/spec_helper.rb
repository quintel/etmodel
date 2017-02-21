ENV["RAILS_ENV"] = 'test'

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec/'
    add_filter 'config/'
    add_group "Models", "app/models"
    add_group "Controllers" do |src|
      src.filename.include?('app/controllers') and
      not src.filename.include?('app/controllers/admin')
    end
    add_group "Admin Controllers", "app/controllers/admin"
  end
end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'authlogic/test_case'
require 'factory_girl'
require 'shoulda/matchers'
require 'vcr'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.javascript_driver = :webkit

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  # If running specs against local etengine server, it would otherwise not
  # be noticed that cassettes might be missing (and that the server is local)
  c.ignore_localhost = false

  c.default_cassette_options = {
    :match_requests_on => [:uri, :method, :body],
    # :once prevents recording new requests when a YAML file already exists
    # matching the spec name. This prevents unintentional creation of new
    # recorded requests. If you intend to record new requests, change this to
    # :new_episodes, run the specs, then change it back to :once.
    :record => :once
  }
  c.debug_logger = File.open Rails.root.join("log/vcr.log"), 'w'
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec

    # Choose one or more libraries:
    with.library :active_record
    with.library :active_model
    # with.library :action_controller
    # Or, choose the following (which implies all of the above):
    # with.library :rails
  end
end

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
  config.use_transactional_fixtures = false

  # config.include Webrat::Matchers
  config.include EtmAuthHelper
  config.include Authlogic::TestCase
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers

  # Database
  # --------

  # Integration tests should use truncation; real requests aren't wrapped
  # in a transaction, so neither should high-level tests. These filters need
  # to be above the filter which starts DatabaseCleaner.

  config.before(:each, type: :request) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each, type: :request) do
    DatabaseCleaner.strategy = :transaction
  end

  # The database_cleaner gem is used to restore the DB to a clean state before
  # each example runs. This is used in preference over rspec-rails'
  # transactions since we also need this behaviour in Cucumber features.

  config.before(:suite) { DatabaseCleaner.strategy = :transaction }
  config.before(:each)  { DatabaseCleaner.start                   }
  config.after(:each)   { DatabaseCleaner.clean                   }

  # Stub out Partner.all.
  [ :controller, :request ].each do |type|
    config.before(:each, type: type) do
      allow(Partner).to receive(:all).and_return([
        Partner.new(name: 'StarTale',   key: 'st', img: '', kind: 'primary'),
        Partner.new(name: 'TeamLiquid', key: 'tl', img: '', kind: 'general')
      ])
    end
  end

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end
