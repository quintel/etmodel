class DescriptionsController < ApplicationController

  #RD: REFACTOR: It does not make sense that in the first the params[:output] is used to set the type and in the second, it is params[:type].
  
  def show
    @description = Description.where(:describable_id => params[:id], :describable_type => params[:output]).first
    if @description.nil? || @description.describable.andand.title_for_description.nil?
      logger.fatal "No description for %s" % params[:id]
      render :text => 'Description is not yet available.'
    end
  end

  def charts
    params[:type] = 'OutputElement'
    @description = Description.where(:describable_id => params[:id], :describable_type => params[:type]).first
    render :show
  end
end
