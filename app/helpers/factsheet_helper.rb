module FactsheetHelper
  def factsheet_client_settings
    url = [APP_CONFIG[:api_url], 'api/v3/scenarios', params[:id]]
      .map { |token| token.to_s.chomp('/') }
      .join('/')

    { endpoint: url }
  end
end
