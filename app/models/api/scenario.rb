class Api::Scenario < ActiveResource::Base
  self.site = "#{APP_CONFIG[:api_url]}/api/v3"

  # description for a locale is enclosed in
  # <span class='en'>
  # </span>
  def description_for_locale(locale)
    html = Nokogiri::HTML.parse(description)
    html.css(".#{locale}").inner_html
  end

  # The JSON request returns a string. Let's make it a DateTime object
  def parsed_created_at
    DateTime.parse(created_at)
  end

  def days_old
    (Time.now - parsed_created_at) / 60 / 60 / 24
  end

end
