raw_config = File.read("#{Rails.root}/config/config.yml")
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys

Airbrake.configure do |config|
  config.api_key = APP_CONFIG[:airbrake_api_key]
end if APP_CONFIG[:airbrake_api_key].present?
