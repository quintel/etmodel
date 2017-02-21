module Admin
  class TabsController < BaseController
    before_action :find_model, :only => [:show, :edit]

    def index
      @tabs = Tab.ordered
    end

    def new
      @tab = Tab.new
      @tab.build_area_dependency
    end

    def create
      @tab = Tab.new(tab_parameters)
      if @tab.save
        flash[:notice] = "Tab saved"
        redirect_to admin_tabs_url
      else
        render :action => 'new'
      end
    end

    def update
      @tab = Tab.find(params[:id])
      if @tab.update_attributes(tab_parameters)
        flash[:notice] = "Tab updated"
        redirect_to admin_tabs_url
      else
        render :action => 'edit'
      end
    end

    def destroy
    end

    def edit
      @tab.build_area_dependency unless @tab.area_dependency
    end

    def show
    end

    #######
    private
    #######

    def find_model
      if params[:version_id]
        @version = Version.find(params[:version_id])
        @tab = @version.reify
        flash[:notice] = "Revision"
      else
        @tab = Tab.find(params[:id])
      end
    end

    def tab_parameters
      params.require(:tab).permit!
    end
  end
end
