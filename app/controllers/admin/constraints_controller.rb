module Admin
  class ConstraintsController < BaseController
    before_filter :find_element, :only => [:show, :edit, :update, :destroy]

    def index
      @constraints = Constraint.all
    end

    def new
      @constraint = Constraint.new
      @constraint.build_description
    end

    def create
      @constraint = Constraint.new(params[:constraint])

      if @constraint.save
        flash[:notice] = "Constraint saved"
        redirect_to admin_constraints_url
      else
        render :action => 'new'
      end
    end

    def update
      if @constraint.update_attributes(params[:constraint])
        flash[:notice] = "Constraint updated"
        redirect_to admin_constraints_url
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
    end

    private

      def find_element
        if params[:version_id]
          @version = Version.find(params[:version_id])
          @constraint = @version.reify
          flash[:notice] = "Revision"
        else
          @constraint = Constraint.find(params[:id])
        end
      end
  end
end
