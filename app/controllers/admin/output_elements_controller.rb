module Admin
class OutputElementsController < BaseController
  before_filter :find_element, :only => [:show, :edit, :update, :destroy]

  def index
    @output_elements = OutputElement.all
  end

  def new
    @output_element = OutputElement.new
    @output_element.build_description
    @output_element.build_area_dependency
  end

  def create
    @output_element = OutputElement.new(params[:output_element])

    if @output_element.save
      flash[:notice] = "OutputElement saved"
      redirect_to admin_output_elements_url
    else
      render :action => 'new'
    end
  end

  def update
    if @output_element.update_attributes(params[:output_element])
      ["nl","en"].each do |l|
        expire_fragment("slider_#{@output_element.id}_#{l}")
      end
      flash[:notice] = "OutputElement updated"
      redirect_to admin_output_elements_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @output_element.destroy
      flash[:notice] = "Successfully destroyed output_element."
      redirect_to admin_output_elements_url
    else
      flash[:error] = "Error while deleting output_element."
      redirect_to admin_output_elements_url
    end
  end

  def show
  end

  def edit
    @output_element.build_description unless @output_element.description
    @output_element.build_area_dependency unless @output_element.area_dependency
  end

  private
  
    def find_element
      if params[:version_id]
        @version = Version.find(params[:version_id])
        @output_element = @version.reify
        flash[:notice] = "Revision"
      else
        @output_element = OutputElement.find(params[:id])
      end
    end

end
end