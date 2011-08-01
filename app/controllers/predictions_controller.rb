class PredictionsController < ApplicationController
  def index
    @input_element = InputElement.find(params[:input_element_id])
    @prediction = @input_element.predictions.find(params[:prediction_id]) || @input_element.predictions.first
    @comment = Comment.new
    @comment.commentable = @prediction#(:commentable_id => @prediction.id, :commentable_type => 'Prediction')
  end
  
  def show
    @prediction = Prediction.find params[:id]
    @comment = Comment.new
    @comment.commentable = @prediction#(:commentable_id => @prediction.id, :commentable_type => 'Prediction')
    render :layout => false if request.xhr?    
  end
  
  def comment
    @prediction = Prediction.find(params[:id])
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
end
