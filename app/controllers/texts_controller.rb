class TextsController < ApplicationController
  layout 'iframe'

  def show
    @text = Text.where(key: params[:id]).first
    if @text.nil? || @text.content.nil?
      logger.fatal "No Text for %s" % params[:id]
      render text: 'Text is not yet available.'
    end
    render layout: false if request.xhr?
  end
end
