class ConstraintsController < ApplicationController
  def show
  end
  
  def iframe
    @api_client = Api::Client.new
    api_key = Current.setting.api_session_key rescue nil
  
    # be sure we're using the current session id
    # The client is smart enough to fetch a fresh session_id if missing
    @api_client.api_session_id = api_key
    
    # We don't need to fetch the object from the db
    @constraint_id = params[:id]
    
    render :layout => 'constraint_iframe'
  end  
end
