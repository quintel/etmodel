# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'active_resource'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Etm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.autoload_paths += [Rails.root.join('lib').to_s]

    config.time_zone = 'Etc/UTC'
    config.encoding = 'utf-8'

    config.i18n.available_locales = %i[en nl]
    config.i18n.load_path += Dir[Rails.root.join('config','locales','**/*.yml')]

    config.generators do |g|
      g.template_engine :haml
      g.test_framework  :rspec, fixture: false
    end

    # Custom 404 and 500 page
    config.exceptions_app = routes
  end

  Date::DATE_FORMATS[:default] = '%d-%m-%Y'
end
