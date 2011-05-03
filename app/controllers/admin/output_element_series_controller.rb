class Admin::OutputElementSeriesController  < Admin::AdminController

  def index
    @output_element_series = OutputElementSerie.ordered_for_admin
  end


  def new
    @output_element_serie = OutputElementSerie.new
  end

  def create
    @output_element_serie = OutputElementSerie.new(params[:output_element_serie])

    if @output_element_serie.save
      flash[:notice] = "OutputElementSerie saved"
      redirect_to admin_output_element_series_url
    else
      render :action => 'new'
    end
  end

  def update
    @output_element_serie = OutputElementSerie.find(params[:id])

    if @output_element_serie.update_attributes(params[:output_element_serie])
      flash[:notice] = "OutputElementSerie updated"
      redirect_to admin_output_element_series_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @output_element_serie = OutputElementSerie.find(params[:id])
    if @output_element_serie.destroy
      flash[:notice] = "Successfully destroyed input_element."
      redirect_to admin_output_element_series_url
    else
      flash[:error] = "Error while deleting slider."
      redirect_to admin_output_element_series_url
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
      @output_element_serie = @version.reify
      flash[:notice] = "Revision"
    else
      @output_element_serie = OutputElementSerie.find(params[:id])
    end
  end
end
