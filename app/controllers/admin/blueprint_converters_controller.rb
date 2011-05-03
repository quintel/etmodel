class Admin::BlueprintConvertersController  < Admin::AdminController
  before_filter :deprecated_admin_area_notice

  before_filter :find_parent
  before_filter :find_model, :only => [:show, :edit, :update, :destroy]

  def index
    Current.graph_id = params[:graph_id] if params[:graph_id]
    @attributes = (params[:attributes] || '').split(',')

    @blueprint_converters = if @blueprint
      @blueprint.converters
    else
      Converter.all
    end
  end

  def show
  end

  def new
    @blueprint_converter = Converter.new
  end

  def edit
  end

  def create
    @blueprint_converter = Converter.new(params[:blueprint_converter])
    if @blueprint_converter.save
      flash[:notice] = "Converter created"
      redirect_to admin_blueprint_converters_url
    else
      render :action => 'new'
    end
  end

  def update
    if @blueprint_converter.update_attributes(params[:blueprint_converter])
      flash[:notice] = "Successfully updated blueprint_converter."
      redirect_to admin_blueprint_converters_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @blueprint_converter.destroy
      flash[:notice] = "Successfully deleted Converter"
      redirect_to :back
    else
      flash[:error] = "Converter not deleted"
      redirect_to :back
    end
  end

  def find_parent
    @blueprint = Blueprint.find(params[:blueprint_id]) if params[:blueprint_id]
  end

  def find_model
    @blueprint_converter = Converter.find(params[:id])
  end
end
