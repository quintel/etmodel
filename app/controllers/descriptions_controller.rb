class DescriptionsController < ApplicationController
  def show
    @description = Description.find(params[:id]) rescue nil
    if @description.nil? || @description.title.blank?
      render :text => 'Description is not yet available.'
    end
  end

  ##
  # This is used in the '?'- button for output elements. It gets the description using the outputelement id
  def charts
    @description = Description.where(:describable_id => params[:id], :describable_type => 'OutputElement').first
    render :show
  end
end
