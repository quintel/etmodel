module Admin
class SlidesController < BaseController
  before_filter :find_model, :only => [:edit, :show]

  def index
    @slides = Slide.all
  end

  def new
    @slide = Slide.new
    @slide.build_description
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
  end

  def edit
    @slide.build_description unless @slide.description
  end
  
  private

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