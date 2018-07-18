module FactsheetHelper
  def factsheet_client_settings
    url = [APP_CONFIG[:api_url], 'api/v3/scenarios', params[:id]]
      .map { |token| token.to_s.chomp('/') }
      .join('/')

    { endpoint: url }
  end

  def can_dismiss_disclaimer?
    current_user.admin? || current_user.role.try(:name) == 'overmorgen'
  end
end
