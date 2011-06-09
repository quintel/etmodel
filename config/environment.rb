# Load the rails application
require File.expand_path('../application', __FILE__)
Encoding.default_external = Encoding::UTF_8

# Ruby is using Psych for YAML parsing, and the 1.9.2 version
# of Psych can't handle merge keys (eg. <<: *default)
# see http://www.rubyinside.com/get-edge-ruby-faster-loading-ruby-1-9-2-now-4973.html
YAML::ENGINE.yamler = 'syck'

# Initialize the rails application
Etm::Application.initialize!
