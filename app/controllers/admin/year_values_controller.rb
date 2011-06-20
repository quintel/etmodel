module Admin
class YearValuesController < BaseController

  def index
    @year_values = YearValue.all
  end

  def new
    @year_value = YearValue.new
  end

  def create
    @year_value = YearValue.new(params[:year_value])

    if @year_value.save
      flash[:notice] = "YearValue saved"
      redirect_to :back
    else
      render :action => 'new'
    end
  end

  def update
    @year_value = YearValue.find(params[:id])

    if @year_value.update_attributes(params[:year_value])
      flash[:notice] = "YearValue updated"
      redirect_to :back
    else
      render :action => 'edit'
    end
  end

  def destroy
    @year_value = YearValue.find(params[:id])
    if @year_value.destroy
      flash[:notice] = "Successfully destroyed historic serie."
      redirect_to admin_year_values_url
    else
      flash[:error] = "Error while deleting historic serie."
      redirect_to admin_year_values_url
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
      @year_value = @version.reify
      flash[:notice] = "Revision"
    else
      @year_value = YearValue.find(params[:id])
    end
  end
end
end