class PredictionsController < ApplicationController
  before_filter :find_input_element, :only => :index
  before_filter :find_prediction, :only => [:show, :comment]
  
  def index
    @predictions = @input_element.available_predictions
    @prediction  = @predictions.find(params[:prediction_id]) rescue @predictions.first
    @comment = Comment.new
    @comment.commentable = @prediction
    @end_year = params[:end_year]

    if has_active_scenario?
      render :layout => 'iframe'
    else
      render :layout => 'pages'
    end
  end
  
  def show
    @input_element = @prediction.input_element
    @comment = Comment.new
    @comment.commentable = @prediction
    render :layout => false if request.xhr?
  end
  
  def comment
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id if current_user
    @comment.commentable = @prediction
    if @comment.save
      flash[:notice] = "Your comment has been added"
    else
      flash[:error] = "Error saving the comment"
    end
    redirect_to predictions_path(:input_element_id => @prediction.input_element_id, :prediction_id => @prediction.id)
  end
  
  private
  
    def find_input_element
      @input_element = InputElement.find(params[:input_element_id])
    end
    
    def find_prediction
      @prediction = Prediction.find(params[:id])
    end
    
    def has_active_scenario?
      Current.setting.api_session_key.present? rescue false
    end
end
