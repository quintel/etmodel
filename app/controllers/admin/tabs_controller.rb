class Admin::TabsController < Admin::AdminController
  def index
    @tabs = Tab.all
    @column_names = %w[id key]
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

  def show
    find_model
  end

  def edit
    find_model
  end

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
