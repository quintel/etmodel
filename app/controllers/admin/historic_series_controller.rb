class Admin::HistoricSeriesController < Admin::AdminController

  def index
    @historic_series = HistoricSerie.all
    # @column_names = %w[id controller_name action_name name default_output_element_id order_by image sub_header complexity]
  end


  def new
    @historic_serie = HistoricSerie.new
  end

  def create
    @historic_serie = HistoricSerie.new(params[:historic_serie])

    if @historic_serie.save
      flash[:notice] = "HistoricSerie saved"
      redirect_to admin_historic_series_url
    else
      render :action => 'new'
    end
  end

  def update
    @historic_serie = HistoricSerie.find(params[:id])

    if @historic_serie.update_attributes(params[:historic_serie])
      flash[:notice] = "HistoricSerie updated"
      redirect_to admin_historic_series_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @historic_serie = HistoricSerie.find(params[:id])
    if @historic_serie.destroy
      flash[:notice] = "Successfully destroyed historic serie."
      redirect_to admin_historic_series_url
    else
      flash[:error] = "Error while deleting historic serie."
      redirect_to admin_historic_series_url
    end
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
      @historic_serie = @version.reify
      flash[:notice] = "Revision"
    else
      @historic_serie = HistoricSerie.find(params[:id])
    end
  end
end
