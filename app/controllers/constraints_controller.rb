class ConstraintsController < ApplicationController
  def show
  end
  
  def iframe
    @constraint = Constraint.find(params[:id]) rescue nil
    render :layout => 'constraint_iframe'
  end
end
