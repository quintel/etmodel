module Admin
class ExpertPredictionsController < BaseController
  # GET /expert_predictions
  # GET /expert_predictions.xml
  def index
    @expert_predictions = ExpertPrediction.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @expert_predictions }
    end
  end

  # GET /expert_predictions/1
  # GET /expert_predictions/1.xml
  def show
    @expert_prediction = ExpertPrediction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @expert_prediction }
    end
  end

  # GET /expert_predictions/new
  # GET /expert_predictions/new.xml
  def new
    @expert_prediction = ExpertPrediction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @expert_prediction }
    end
  end

  # GET /expert_predictions/1/edit
  def edit
    @expert_prediction = ExpertPrediction.find(params[:id])
  end

  # POST /expert_predictions
  # POST /expert_predictions.xml
  def create
    @expert_prediction = ExpertPrediction.new(params[:expert_prediction])

    respond_to do |format|
      if @expert_prediction.save
        flash[:notice] = 'ExpertPrediction was successfully created.'
        format.html { redirect_to admin_expert_predictions_path }
        format.xml  { render :xml => @expert_prediction, :status => :created, :location => @expert_prediction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @expert_prediction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /expert_predictions/1
  # PUT /expert_predictions/1.xml
  def update
    @expert_prediction = ExpertPrediction.find(params[:id])

    respond_to do |format|
      if @expert_prediction.update_attributes(params[:expert_prediction])
        flash[:notice] = 'ExpertPrediction was successfully updated.'
        format.html { redirect_to admin_expert_predictions_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @expert_prediction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /expert_predictions/1
  # DELETE /expert_predictions/1.xml
  def destroy
    @expert_prediction = ExpertPrediction.find(params[:id])
    @expert_prediction.destroy

    respond_to do |format|
      format.html { redirect_to(expert_predictions_url) }
      format.xml  { head :ok }
    end
  end
end
end