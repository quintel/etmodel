require 'rack/sprockets'


Rails.application.config.middleware.use Rack::Sprockets, 
                      :load_path => ["app/javascripts/", "vendor/javascripts/**/src"], 
                      :source => ['app/javascripts/init'], 
                      :hosted_at => '/sprockets'


Rack::Sprockets.configure do |config|
  if Rails.env.production?
    # config.compress = :yui
    config.cache = true
  end
end