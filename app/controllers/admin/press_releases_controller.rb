module Admin
  class PressReleasesController < BaseController
    before_filter :find_press_release, :only => [:show, :edit, :update, :destroy]

    def index
      @releases = PressRelease.order('release_date DESC')
    end

    def new
      @press_release = PressRelease.new
    end

    def create
      @press_release = PressRelease.new(params[:press_release])
      if @press_release.save
        flash[:notice] = "Successfully created release."
        session[:link] = nil
        redirect_to admin_press_releases_url
      else
        render :action => 'new'
      end
    end

    def update
      if @press_release.update_attributes(params[:press_release])
        flash[:notice] = "Successfully updated release."
        session[:link] = nil
        redirect_to admin_press_releases_url
      else
        render :action => 'edit'
      end
    end

    def destroy
      @press_release.destroy
      flash[:notice] = "Successfully destroyed release."
      redirect_to admin_press_releases_url
    end

    def edit
    end

    # Ugly and deprecated. Press releases should soon be moved to the new
    # et-model.com app.
    #
    def upload
      PressRelease.upload_file(params[:press_file])
      flash[:notice] = "File has been uploaded successfully. use as link: /assets/#{params[:press_file].original_filename}"
      session[:link] = "/media/#{params[:press_file].original_filename}"

      redirect_to admin_press_releases_url
    end

    private

    def find_press_release
      @press_release = PressRelease.find(params[:id])
    end
  end
end
