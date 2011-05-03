class Admin::OutputElementsController < Admin::AdminController
  sortable_attributes :name,:group,:percentage,:unit,:output_element_type_id => "`output_element_type_id`"

  def index
    @output_elements = OutputElement.all
  end


  def new
    @output_element = OutputElement.new
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
    @output_element = OutputElement.find(params[:id])

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
    @output_element = OutputElement.find(params[:id])
    if @output_element.destroy
      flash[:notice] = "Successfully destroyed output_element."
      redirect_to admin_output_elements_url
    else
      flash[:error] = "Error while deleting output_elementq."
      redirect_to admin_output_elements_url
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
      @output_element = @version.reify
      flash[:notice] = "Revision"
    else
      @output_element = OutputElement.find(params[:id])
    end
  end

end
