raw_config = File.read("#{Rails.root}/config/config.yml")
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys

Airbrake.configure do |config|
  # You must set both project_id & project_key. To find your project_id and
  # project_key navigate to your project's General Settings and copy the values
  # from the right sidebar.
  # https://github.com/airbrake/airbrake-ruby#project_id--project_key
  config.project_id = APP_CONFIG[:airbrake_project_id]
  config.project_key = APP_CONFIG[:airbrake_api_key]
end if APP_CONFIG[:airbrake_api_key].present?
