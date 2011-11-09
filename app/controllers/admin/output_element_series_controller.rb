module Admin
class OutputElementSeriesController  < BaseController
  before_filter :find_model, :only => [:edit, :show]
  
  def index
    scope = OutputElementSerie
    scope = scope.gquery_contains(params[:gquery]) if params[:gquery]
    @output_element_series = scope.ordered_for_admin
  end


  def new
    @output_element_serie = OutputElementSerie.new(:output_element_id => params[:output_element_id])
    @output_element_serie.build_description
    @output_element_serie.build_area_dependency
  end

  def create
    @output_element_serie = OutputElementSerie.new(params[:output_element_serie])
    if @output_element_serie.save
      flash[:notice] = "OutputElementSerie saved"
      redirect_to admin_output_element_series_path(@output_element_serie)
    else
      render :action => 'new'
    end
  end

  def update
    @output_element_serie = OutputElementSerie.find(params[:id])

    if @output_element_serie.update_attributes(params[:output_element_serie])
      flash[:notice] = "OutputElementSerie updated"
      redirect_to admin_output_element_series_path(@output_element_serie)
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
  end

  def edit
    @output_element_serie.build_description unless @output_element_serie.description
    @output_element_serie.build_area_dependency unless @output_element_serie.area_dependency
  end

  private
  
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
end