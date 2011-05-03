class Admin::AreasController < Admin::AdminController

  before_filter :deprecated_admin_area_notice

  def index
    @areas = Area.all
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new(params[:area])
    if @area.save
      flash[:notice] = "Successfully created area and carrier datas."
      redirect_to [:admin, @area]
    else
      render :action => 'new'
    end
  end

  def update
    @area = Area.find(params[:id])
    if @area.update_attributes(params[:area])
      flash[:notice] = "Successfully updated area."
      redirect_to [:admin, @area]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    flash[:notice] = "Successfully destroyed area."
    redirect_to admin_areas_url
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
      @area = @version.reify
      flash[:notice] = "Revision"
    else
      @area = Area.find(params[:id])
    end
  end
end
