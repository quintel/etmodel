module Admin
class SlidesController < BaseController

  def index
    @slides = Slide.all
    @column_names = %w[id controller_name action_name name default_output_element_id order_by image sub_header complexity]
  end

  def new
    @slide = Slide.new
  end

  def create
    @slide = Slide.new(params[:slide])
    if @slide.save
      flash[:notice] = "Slide saved"
      redirect_to admin_slides_url
    else
      render :action => 'new'
    end
  end

  def update
    @slide = Slide.find(params[:id])
    if @slide.update_attributes(params[:slide])
    flash[:notice] = "Slide updated"
    redirect_to admin_slides_url
    else
      render :action => 'edit'
    end
  end

  def destroy
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
      @slide = @version.reify
      flash[:notice] = "Revision"
    else
      @slide = Slide.find(params[:id])
    end
  end
end
end