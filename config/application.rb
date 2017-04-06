require_relative 'boot'

require 'rails/all'
require 'active_resource'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Etm
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    ## Pseudo-modules
    # I packaged some classes/files separate folders
    # so we need to load them here. This is only for classes
    # that belong together but where it didn't make sense to
    # put them in a module.
    config.autoload_paths += Dir["#{Rails.root}/lib"]

    config.active_support.deprecation = :log
    config.time_zone = 'Amsterdam'

    config.encoding = "utf-8"

    config.generators do |g|
      g.template_engine :haml
      g.test_framework  :rspec, fixture: false
    end

    #custom 404 and 500 page
    config.exceptions_app = self.routes

    #Needed for i18n-js to work
    config.assets.initialize_on_precompile = true
  end

  Date::DATE_FORMATS[:default] = "%d-%m-%Y"
end
