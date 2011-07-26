class DescriptionsController < ApplicationController

  #RD: REFACTOR: It does not make sense that in the first the params[:output] is used to set the type and in the second, it is params[:type].
  
  def show
    @description = Description.find(params[:id]) rescue nil
    if @description.nil? || @description.title.blank?
      render :text => 'Description is not yet available.'
    end
  end

  # TODO: is this used?
  def charts
    params[:type] = 'OutputElement'
    @description = Description.where(:describable_id => params[:id], :describable_type => params[:type]).first
    render :show
  end
end
