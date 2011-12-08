class ConstraintsController < ApplicationController
  def show
    @constraint = Constraint.find(params[:id])
    render :layout => 'constraint_iframe'
  end
end
