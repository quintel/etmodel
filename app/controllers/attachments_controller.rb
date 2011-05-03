# The attachments controller is a resource of: 
#   scenarios
class AttachmentsController < ApplicationController
  layout 'etm'
  before_filter :find_attachment
  
  def show
    
  end
  
  
  def destroy
    @attachment.destroy
    
    respond_to do |format|
      format.html {redirect_to :back}
    end
  end
  
  
  private
  def find_attachment
    @attachment = Attachment.find(params[:id])
    
    if @attachment.attachable.user.id =! current_user.id
      raise HTTPStatus::Forbidden
    end
    
  end
end
