class DescriptionsController < ApplicationController

  # This is used in the '?'- button for output elements. It gets the description
  # using the outputelement key
  def charts
    @chart = OutputElement.find params[:id]

    render :show, layout: false
  end
end
