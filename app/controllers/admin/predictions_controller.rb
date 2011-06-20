module Admin
class PredictionsController < BaseController
  # GET /predictions
  def index
    @predictions = Prediction.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /predictions/1
  def show
    @prediction = Prediction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /predictions/new
  def new
    @prediction = Prediction.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /predictions/1/edit
  def edit
    @prediction = Prediction.find(params[:id])
  end

  # POST /predictions
  def create
    @prediction = Prediction.new(params[:prediction])
    respond_to do |format|
      if @prediction.save
        flash[:notice] = 'Prediction was successfully created.'
        format.html { redirect_to admin_predictions_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /predictions/1
  def update
    @prediction = Prediction.find(params[:id])
    respond_to do |format|
      if @prediction.update_attributes(params[:prediction])
        flash[:notice] = 'Prediction was successfully updated.'
        format.html { redirect_to admin_predictions_path }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /predictions/1
  def destroy
    @prediction = Prediction.find(params[:id])
    @prediction.destroy

    respond_to do |format|
      format.html { redirect_to(admin_predictions_url) }
    end
  end
  
end
end