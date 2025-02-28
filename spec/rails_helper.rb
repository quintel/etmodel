# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
ENV['MY_API_TOKEN'] = 'dummy_token'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rails'
require 'shoulda/matchers'
require 'vcr'

require 'identity/test/controller_helpers'
require 'identity/test/system_helpers'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.javascript_driver = :webkit

VCR.configure do |c|
  c.filter_sensitive_data('<MY_API_TOKEN>') { ENV['MY_API_TOKEN'] }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.before_record do |interaction|
    interaction.request.headers.delete('Authorization')
  end

  # If running specs against local etengine server, it would otherwise not
  # be noticed that cassettes might be missing (and that the server is local)
  c.ignore_localhost = false

  c.default_cassette_options = {
    match_requests_on: [:uri, :method, :body],
    # :once prevents recording new requests when a YAML file already exists
    # matching the spec name. This prevents unintentional creation of new
    # recorded requests. If you intend to record new requests, change this to
    # :new_episodes, run the specs, then change it back to :once.
    record: :once
  }
  c.debug_logger = File.open Rails.root.join("log/vcr.log"), 'w'

  # Permit requests for webdrivers used in system tests.
  c.ignore_hosts 'chromedriver.storage.googleapis.com', '127.0.0.1'

  c.around_http_request do |request|
    uri = URI(request.uri)

    # require 'pry'
    # binding.pry
    if uri.path == '/api/v3/areas.json' && uri.query == 'detailed=false'
      # Redirect the standard areas.json request to a specific cassette so that
      # we don't need to store many copies.
      VCR.use_cassette('areas', &request)
    elsif uri.path == '/api/v3/scenarios/templates.json'
      VCR.use_cassette('presets', &request)
    else
      request.proceed
    end
  end


  c.ignore_request do |request|
    ## Ignore requests made for accesstokens
    URI(request.uri).path == '/identity/access_tokens'
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = ["#{::Rails.root}/spec/fixtures"]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include Identity::Test::ControllerHelpers, type: :controller
  config.include RequestHelpers, type: :request
  config.include RequestHelpers, type: :system

  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
  config.include FactoryBot::Syntax::Methods

  config.before(:each, type: :controller) do
    allow(Engine::Area).to receive(:code_exists?).and_return(true)
  end

  config.before(:each, :api) do
    config.include JWTHelper
  end

  config.before(:each, type: :service) do
    config.include ServicesHelper
  end

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
end
