# frozen_string_literal: true

# Sends a signed-in caller once through MyETM's open by Session ID when their cookie holds no grant
# at the given level for the Session being loaded. MyETM grants their role, then returns them to the
# load with `granted` set so it does not bounce again.
module LoadBouncesForGrant
  private

  def bounce_for_grant(session_id, return_to, level: :write)
    return unless needs_grant?(session_id, level)

    redirect_to(my_etm_open_url(session_id, return_to), allow_other_host: true)
  end

  def needs_grant?(session_id, level)
    signed_in? && params[:granted].blank? && !granted?(session_id, level)
  end

  def granted?(session_id, level)
    level == :read ? scenario_access.readable?(session_id) : scenario_access.writable?(session_id)
  end

  def scenario_access
    Identity::ScenarioAccess.new(identity_token[Identity::ScenarioAccess::CLAIM], tag: Settings.version)
  end

  def my_etm_open_url(session_id, return_to)
    "#{Settings.identity.issuer}/saved_scenarios/open?#{{ session_ids: session_id, return_to: }.to_query}"
  end
end
