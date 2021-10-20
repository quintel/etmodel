# frozen_string_literal: true

# Helper methods for the energy mix infographic
module EnergyMixHelper
  def energy_mix_client_settings
    url = [Settings.api_url, 'api/v3/scenarios', params[:id]]
      .map { |token| token.to_s.chomp('/') }
      .join('/')

    { endpoint: url }
  end

  def can_dismiss_disclaimer?
    current_user &&
      (current_user.admin? || current_user.role.try(:name) == 'overmorgen')
  end
end
