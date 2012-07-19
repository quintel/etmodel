module Admin
  class TabsController < BaseController
    before_filter :find_model, :only => [:show, :edit]

    def index
      @tabs = Tab.ordered
    end

    def new
      @tab = Tab.new
    end

    def create
      @tab = Tab.new(params[:tab])
      if @tab.save
        flash[:notice] = "Tab saved"
        redirect_to admin_tabs_url
      else
        render :action => 'new'
      end
    end

    def update
      @tab = Tab.find(params[:id])
      if @tab.update_attributes(params[:tab])
        flash[:notice] = "Tab updated"
        redirect_to admin_tabs_url
      else
        render :action => 'edit'
      end
    end

    def destroy
    end

    def edit
    end

    def show
    end

    private

    def find_model
      if params[:version_id]
        @version = Version.find(params[:version_id])
        @tab = @version.reify
        flash[:notice] = "Revision"
      else
        @tab = Tab.find(params[:id])
      end
    end
  end
end
