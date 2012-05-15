class TranslationsController < ApplicationController
  layout 'iframe'

  #RD: REFACTOR: It does not make sense that in the first the params[:output] is used to set the type and in the second, it is params[:type].

  def show
    @translation = Translation.where(:key => params[:id]).first
    if @translation.nil? || @translation.content.nil?
      logger.fatal "No Text for %s" % params[:id]
      render :text => 'Text is not yet available.'
    end
  end

end
