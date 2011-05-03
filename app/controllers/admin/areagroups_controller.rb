class Admin::AreagroupsController < Admin::AdminController

  def index
    @area_groups = Areagroup.all
  end

  def new
    @area_group = Areagroup.new
  end

  def create
    @area_group = Areagroup.new(params[:areagroup])
    if @area_group.save
      flash[:notice] = "Successfully created area_group and carrier datas."
      redirect_to [:admin, @area_group]
    else
      render :action => 'new'
    end
  end

  def update
    @area_group = Areagroup.find(params[:id])
    if @area_group.update_attributes(params[:areagroup])
      flash[:notice] = "Successfully updated area_group."
      redirect_to [:admin, @area_group]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @area_group = Areagroup.find(params[:id])
    @area_group.destroy
    flash[:notice] = "Successfully destroyed area_group."
    redirect_to admin_area_groups_url
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
      @area_group = @version.reify
      flash[:notice] = "Revision"
    else
      @area_group = Areagroup.find(params[:id])
    end
  end
end
