module Admin
  class SlidesController < BaseController
    before_filter :find_model, :only => [:edit, :destroy]

    def index
      if params[:sidebar_item_id]
        @sidebar_item = SidebarItem.find params[:sidebar_item_id]
        @slides = @sidebar_item.slides.ordered
      else
        @slides = Slide.order('sidebar_item_id, position')
      end
    end

    def new
      @slide = Slide.new
      @slide.build_description
      @slide.build_area_dependency
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
      @slide.destroy
      redirect_to admin_slides_path, :notice => 'Slide deleted'
    end

    def edit
      @slide.build_description unless @slide.description
      @slide.build_area_dependency unless @slide.area_dependency
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
