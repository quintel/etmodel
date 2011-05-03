class Admin::CarrierDatasController < Admin::AdminController
  before_filter :deprecated_admin_area_notice

  # before_filter :find_area
  # 
  # def find_area
  #   @area = Area.find(params[:area_id])
  # end

  def index
    @areagroup = Areagroup.find(params[:areagroup])
    # raise @areagroup.areas.inspect
    @carriers = Carrier.all
  end

  def new
    @carrier_datas = @area.carrier_datas.build
  end
  
  def update_by_areagroup
    @areagroup = Areagroup.find(params[:areagroup])
    @carrier = Carrier.find(params[:carrier])
  end

  def create
    @carrier_data = CarrierData.new(params[:carrier_data])
    if @carrier_data.save
      flash[:notice] = "Successfully created carrier_data."
      redirect_to admin_area_carrier_datas_url(@area)
    else
      render :action => 'new'
    end
  end

  def update
    @areagroup = Areagroup.find(params[:areagroup])
    @areagroup.areas.each do |area|
      area.carrier_datas.select{|c| c.carrier_id.to_i == params[:carrier_id].to_i}.each do |carrier_data|
        if carrier_data.update_attributes(params[:carrier_data])

        else
          render :action => 'edit'
          false
        end
      end
    end
    flash[:notice] = "Successfully updated carrier_data."
    redirect_to admin_carriers_url
  end

  def destroy
    @carrier_data = CarrierData.find(params[:id])
    @carrier_data.destroy
    flash[:notice] = "Successfully destroyed carrier_data."
    redirect_to [:admin, @area]
  end


  def edit
    find_model
  end

  def find_model
    if params[:version_id]
      @version = Version.find(params[:version_id])
      @carrier_data = @version.reify
      flash[:notice] = "Revision"
    else
      @carrier_data = CarrierData.find(params[:id])
    end
  end
end
