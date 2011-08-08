module Admin
  class DescriptionsController < BaseController
    before_filter :find_model, :only => [:show, :edit]

    def index
      @descriptions = Description.page(params[:page]).per(50)
    end

    def new
      @description = Description.new
    end

    def create
      @description = Description.new(params[:description])
      if @description.save
        flash[:notice] = "Description saved"
        redirect_to admin_descriptions_url
      else
        render :action => 'new'
      end
    end

    def update
      @description = Description.find(params[:id])
      if @description.update_attributes(params[:description])
        flash[:notice] = "Description updated"
        redirect_to admin_descriptions_url
      else
        render :action => 'edit'
      end
    end

    def edit
    end
    
    def show
    end
    
    def destroy
    end

    private

      def find_model
        if params[:version_id]
          @version = Version.find(params[:version_id])
          @description = @version.reify
          flash[:notice] = "Revision"
        else
          @description = Description.find(params[:id])
        end
      end
  end
end
