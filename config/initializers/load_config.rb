raw_config = File.read("#{Rails.root}/config/config.yml")
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys

if APP_CONFIG[:sentry_dsn]
  Raven.configure do |config|
    config.dsn = APP_CONFIG[:sentry_dsn]
    config.environments = %w[production staging]

    config.sanitize_fields =
      Rails.application.config.filter_parameters.map(&:to_s)
  end
end
