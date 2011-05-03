class Admin::GroupsController  < Admin::AdminController
  before_filter :find_blueprint
  before_filter :find_model, :only => [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = "Group created"
      redirect_to admin_groups_url
    else
      render :action => 'new'
    end
  end

  def update
    if @group.update_attributes(params[:group])
      flash[:notice] = "Successfully updated group."
      redirect_to admin_groups_url
    else
      render :action => 'edit'
    end
  end

  def find_blueprint
    @blueprint = Blueprint.find(params[:blueprint_id]) if params[:blueprint_id]
  end

  def find_model
    @group = Group.find(params[:id])
  end
end
