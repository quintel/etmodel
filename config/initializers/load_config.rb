raw_config = File.read("#{Rails.root}/config/config.yml")
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys

HoptoadNotifier.configure do |config|
  config.api_key = APP_CONFIG[:hoptoad_api_key]
end if APP_CONFIG[:hoptoad_api_key].present?
