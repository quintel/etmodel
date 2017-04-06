# Load the rails application
require File.expand_path('../application', __FILE__)
Encoding.default_external = Encoding::UTF_8

# Initialize the rails application
Rails.application.initialize!

# Required to get handle links and assets correctly
# ActionMailer::Base.asset_host                 = "http://www.energytransitionmodel.com"
# ActionMailer::Base.default_url_options[:host] = "energytransitionmodel.com"
