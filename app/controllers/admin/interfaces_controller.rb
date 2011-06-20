class Admin::InterfacesController < Admin::AdminController
  before_filter :find_interface, :only => [:show, :edit, :update, :destroy]
  def index
    @interfaces = Interface.all
  end
  
  def new
    @interface = Interface.new
  end
  
  def show
  end
  
  def edit
  end
  
  def create
    @interface = Interface.new(params[:interface])
    if @interface.save
      redirect_to admin_interface_path(@interface), :notice => "Interface added"
    else
      render :new
    end
  end
  
  def update
    if @interface.update_attributes(params[:interface])
      redirect_to admin_interface_path(@interface), :notice => "Interface updated"
    else
      render :edit
    end
  end
  
  def destroy
    @interface.destroy
    redirect_to admin_interfaces_path, :notice => "Interface deleted"
  end
  
  private
  
    def find_interface
      @interface = Interface.find(params[:id])
    end
end
