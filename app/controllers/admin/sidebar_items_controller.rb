module Admin
class SidebarItemsController < BaseController

  def index
    @sidebar_items = SidebarItem.all
    @column_names = %w[id key section percentage_bar_query]
  end

  def new
    @sidebar_item = SidebarItem.new
  end

  def create
    @sidebar_item = SidebarItem.new(params[:sidebar_item])
    if @sidebar_item.save
      flash[:notice] = "category saved"
      redirect_to admin_sidebar_items_url
    else
      render :action => 'new'
    end
  end

  def update
    @sidebar_item = SidebarItem.find(params[:id])
    if @sidebar_item.update_attributes(params[:sidebar_item])
    flash[:notice] = "category updated"
    redirect_to admin_sidebar_items_url
    else
      render :action => 'edit'
    end
  end

  def destroy
  end

  def show
    find_model
  end

  def edit
    find_model
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