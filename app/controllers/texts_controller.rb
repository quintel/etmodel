class TextsController < ApplicationController
  layout 'iframe'

  #RD: REFACTOR: It does not make sense that in the first the params[:output] is used to set the type and in the second, it is params[:type].

  def show
    @text = Text.where(:key => params[:id]).first
    if @text.nil? || @text.content.nil?
      logger.fatal "No Text for %s" % params[:id]
      render :text => 'Text is not yet available.'
    end
    render :layout => false if request.xhr?
  end

end
