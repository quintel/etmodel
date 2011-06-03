class ConstraintsController < ApplicationController
  def show
  end
  
  def iframe
    # DEBT: I'm not happy with name and interface of Api::Query.
    # rename it to Api::Client or something like that
    @api_client = Api::Query.new
    api_key = Current.setting.api_session_key rescue nil
    Rails.logger.debug "*** API KEY: #{api_key}"
    # DEBT: be sure we're using the current session id
    @api_client.api_session_id = api_key || @api_client.fresh_session_id
    
    @constraint = Constraint.find(params[:id]) rescue nil
    render :layout => 'constraint_iframe'
  end
end
