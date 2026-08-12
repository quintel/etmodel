# frozen_string_literal: true

# Helper methods for the energy mix infographic
module EnergyMixHelper
  def energy_mix_client_settings
    url = [Settings.ete_url, 'api/v3/scenarios', params[:id]]
      .map { |token| token.to_s.chomp('/') }
      .join('/')

    { endpoint: url, token: session_access_token }
  end

  def can_dismiss_disclaimer?
    current_user && current_user.admin?
  end
end
