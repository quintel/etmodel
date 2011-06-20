module Admin
class PressReleasesController < BaseController

  def index
    @releases = PressRelease.all
  end

  def new
    @press_release = PressRelease.new
  end

  def create
    @press_release = PressRelease.new(params[:press_release])
    if @press_release.save
      flash[:notice] = "Successfully created release."
      redirect_to admin_press_releases_url
    else
      render :action => 'new'
    end
  end

  def update
    @press_release = PressRelease.find(params[:id])
    if @press_release.update_attributes(params[:press_release])
      flash[:notice] = "Successfully updated release."
      redirect_to admin_press_releases_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @press_release = PressRelease.find(params[:id])
    @press_release.destroy
    flash[:notice] = "Successfully destroyed release."
    redirect_to admin_press_releases_url
  end

  def show
    @press_release = PressRelease.find(params[:id])
  end

  def edit
    @press_release = PressRelease.find(params[:id])
  end
  
  def upload
    PressRelease.upload_file(params[:press_file])
    flash[:notice] = "File has been uploaded successfully. use as link: /assets/#{params[:press_file].original_filename}"
    redirect_to :back
  end
end
end