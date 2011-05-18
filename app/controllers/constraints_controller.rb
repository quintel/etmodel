class ConstraintsController < ApplicationController
  def show
  end
  
  def iframe
    @constraint = Constraint.find(params[:id]) rescue nil
  end
end
