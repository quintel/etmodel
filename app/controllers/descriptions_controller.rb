class DescriptionsController < ApplicationController
  def show
    @description = Description.find(params[:id]) rescue nil
    if @description.nil?
      render text: 'Description is not yet available.'
    end
    render layout: false if request.xhr?
  end

  # This is used in the '?'- button for output elements. It gets the description
  # using the outputelement id
  def charts
    chart = OutputElement.find params[:id]
    @description = chart.try :description
    render :show, layout: false
  end
end
