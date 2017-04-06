class ConstraintsController < ApplicationController
  def show
    @constraint = Constraint.find(params[:id])
    render layout: false
  end
end
