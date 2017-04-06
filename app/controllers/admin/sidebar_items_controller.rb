module Admin
  class SidebarItemsController < BaseController
    before_action :find_model, only: [:show, :edit]

    def index
      if params[:tab_id]
        @tab = Tab.find params[:tab_id]
        @sidebar_items = @tab.sidebar_items
      else
        @sidebar_items = SidebarItem.all
      end
    end

    def new
      @sidebar_item = SidebarItem.new
      @sidebar_item.build_description
      @sidebar_item.build_area_dependency
    end

    def create
      @sidebar_item = SidebarItem.new(sidebar_item_parameters)
      if @sidebar_item.save
        flash[:notice] = "category saved"
        redirect_to admin_sidebar_items_url
      else
        render action: 'new'
      end
    end

    def update
      @sidebar_item = SidebarItem.find(params[:id])
      if @sidebar_item.update_attributes(sidebar_item_parameters)
        flash[:notice] = "category updated"
        redirect_to admin_sidebar_items_url
      else
        render action: 'edit'
      end
    end

    def destroy
    end

    def show
    end

    def edit
      @sidebar_item.build_description unless @sidebar_item.description
      @sidebar_item.build_area_dependency unless @sidebar_item.area_dependency
    end

    #######
    private
    #######

    def sidebar_item_parameters
      params.require(:sidebar_item).permit!
    end

    def find_model
      if params[:version_id]
        @version = Version.find(params[:version_id])
        @sidebar_item = @version.reify
        flash[:notice] = "Revision"
      else
        @sidebar_item = SidebarItem.find(params[:id])
      end
    end
  end
end
