# frozen_string_literal: true

require 'ymodel/base'
require 'ymodel/errors'
require 'ymodel/dump'

require 'ymodel/railtie' if defined?(Rails)

# An ActiveRecord like interface for wrapping YAML files
module YModel
  VERSION = '0.1.0'

  include Errors
end
