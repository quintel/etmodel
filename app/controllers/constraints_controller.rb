class ConstraintsController < ApplicationController
  respond_to :html, :js

  # TODO constraints/1 is called with JS format. Should be HTML
  def show
    @constraint = Constraint.all.detect{|c| c.id == params[:id].to_i}

    respond_with(@constraint)
  end

end
