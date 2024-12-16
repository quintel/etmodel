# frozen_string_literal: true

class VersionsController < ActionController::API
  def index
    versions = Rails.cache.fetch('versions', expires_in 1.day) do
      FetchAPIScenarioInputs.call(ETModel::Clients.idp_client, current_user)
    )
    end

    render json: { versions: versions }, status: :ok
  end

end
