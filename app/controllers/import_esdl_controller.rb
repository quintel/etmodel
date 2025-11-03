# frozen_string_literal: true

# Only index and create. Calls a service that generates an ETE scenario based on the
# specified ESDL file. The service returns the scenario_id when (fully) succesful.
class ImportEsdlController < ApplicationController
  before_action :ensure_esdl_enabled

  def index;end

  private

  def ensure_esdl_enabled
    redirect_to(root_url) unless Settings.esdl_ete_url
  end
end
