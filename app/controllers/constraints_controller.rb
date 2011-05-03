class ConstraintsController < ApplicationController
  respond_to :html, :js
  # before_filter :load_view_settings, :on => [:show]
  def index
    respond_to do |format|
      format.json do
        render :update do |page|
          controller.page_update_constraints(page)
        end
      end
    end
  end

  # TODO constraints/1 is called with JS format. Should be HTML
  def show
    @constraint = Constraint.all.detect{|c| c.id == params[:id].to_i}

    respond_with(@constraint)
  end

end
