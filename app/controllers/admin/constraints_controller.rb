module Admin
  class ConstraintsController < BaseController
    before_action :find_element, :only => [:show, :edit, :update, :destroy]

    def index
      @constraints = Constraint.all
    end

    def new
      @constraint = Constraint.new
      @constraint.build_description
      @constraint.build_area_dependency
    end

    def create
      @constraint = Constraint.new(constraint_parameters)

      if @constraint.save
        flash[:notice] = "Constraint saved"
        redirect_to admin_constraint_path(@constraint)
      else
        render :action => 'new'
      end
    end

    def update
      if @constraint.update_attributes(constraint_parameters)
        flash[:notice] = "Constraint updated"
        redirect_to admin_constraint_path(@constraint)
      else
        render :action => 'edit'
      end
    end

    def destroy
      if @constraint.destroy
        flash[:notice] = "Successfully destroyed constraint."
        redirect_to admin_constraints_url
      else
        flash[:error] = "Error while deleting constraint."
        redirect_to admin_constraints_url
      end
    end

    def show
    end

    def edit
      @constraint.build_description unless @constraint.description
      @constraint.build_area_dependency unless @constraint.area_dependency
    end

    #######
    private
    #######

    def find_element
      if params[:version_id]
        @version = Version.find(params[:version_id])
        @constraint = @version.reify
        flash[:notice] = "Revision"
      else
        @constraint = Constraint.find(params[:id])
      end
    end

    def constraint_parameters
      params.require(:constraint).permit!
    end
  end
end
