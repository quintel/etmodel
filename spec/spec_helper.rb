if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
#require 'spec/autorun'
#require 'spec/rails'
#require "selenium/client"
#gem "selenium-client"

require 'webrat'

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}
Dir[File.expand_path(File.join(File.dirname(__FILE__),'factories','**','*.rb'))].each {|f| require f}

#Dir[File.expand_path(File.join(File.dirname(__FILE__),'pkg/optimizer/opt','**','*.rb'))].each {|f| require f}

# handy function to load a fixed graph to which the tests apply
# def load_gql_fixture ; Marshal.load(File.read(File.join(Rails.root, "db/seed/test-gql.dump"))) ; end
def load_gql_fixture ; Marshal.load(File.read(File.join(Rails.root, "spec/fixtures/gql.dump"))) ; end

# load consistent set of queries (including those in policy_goals and constraints)
require 'active_record/fixtures'
def load_fixtures
  fixtures_path = "spec/fixtures"
  Dir[Rails.root.join(fixtures_path, "*.{yml,csv}").to_s].each do |file|
    Fixtures.create_fixtures(fixtures_path, File.basename(file, '.*'))
  end
end

def load_carriers
  fixtures_path = "spec/fixtures"
  Carrier.delete_all
  Fixtures.create_fixtures(fixtures_path, File.basename('carriers', '.*'))
  # 
  Qernel::ConverterApi.create_methods_for_each_carrier(::Carrier.all.map(&:key))
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false

  require File.join(Rails.root, 'db', 'seeds.rb')

  config.include(CustomMatchers)
  config.include(EtmHelper)
  config.include(Webrat::Matchers, :type => :views)
end
