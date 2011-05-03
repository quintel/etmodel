class Admin::BlueprintsController  < Admin::AdminController
  before_filter :deprecated_admin_area_notice

  before_filter :find_model, :only => [:show, :edit, :update, :destroy]

  def index
    @blueprints = Blueprint.ordered
  end

  def graph
    render :layout => false
  end

  def show

  end

  def new
    @blueprint = Blueprint.new
  end

  def edit
  end

  def create
    @blueprint = Blueprint.new(params[:blueprint])
    if @blueprint.save
      flash[:notice] = "Blueprint created"
      redirect_to admin_blueprints_url
    else
      render :action => 'new'
    end
  end

  def update
    if @blueprint.update_attributes(params[:blueprint])
      flash[:notice] = "Successfully updated blueprint."
      redirect_to admin_blueprints_url
    else
      render :action => 'edit'
    end
  end

  def find_model
    @blueprint = Blueprint.find(params[:id])
  end
end
