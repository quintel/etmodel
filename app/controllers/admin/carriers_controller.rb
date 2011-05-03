class Admin::CarriersController < Admin::AdminController
  before_filter :deprecated_admin_area_notice

  def index
    @area_groups = Areagroup.all
  end

  def new
    @carriers = Carrier.new
  end

  def create
    @carrier = Carrier.new(params[:carrier])
    if @carrier.save
      flash[:notice] = "Successfully created carrier."
      redirect_to [:admin, @carrier]
    else
      render :action => 'new'
    end
  end

  def update
    @carrier = Carrier.find(params[:id])
    if @carrier.update_attributes(params[:carrier])
      flash[:notice] = "Successfully updated carrier."
      redirect_to [:admin, @carrier]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @carrier = Carrier.find(params[:id])
    @carrier.destroy
    flash[:notice] = "Successfully destroyed carrier."
    redirect_to admin_carriers_url
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
      @carrier = @version.reify
      flash[:notice] = "Revision"
    else
      @carrier = Carrier.find(params[:id])
    end
  end
end
