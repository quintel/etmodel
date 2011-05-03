class Admin::TranslationsController < Admin::AdminController

  def index
    @translations = Translation.all
  end

  def edit
    @translation = Translation.find_by_id(params[:id])
  end

  def update
    @translation = Translation.find(params[:id])
    if @translation.update_attributes(params[:translation])
      flash[:notice] = "Successfully updated translation."
      redirect_to admin_translations_url
    else
      render :action => 'edit'
    end
  end

  def new
    @translation = Translation.new()
  end

  def create
    @translation = Translation.new(params[:translation])
    if @translation.save
      flash[:notice] = "Successfully created a new translation."
      redirect_to admin_translations_url
    else
      redirect_to :back
    end
  end


end
