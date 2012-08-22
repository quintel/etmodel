class PredictionsController < ApplicationController
  before_filter :find_input_element, :only => :index
  before_filter :find_prediction, :only => [:show, :comment, :share]

  def index
    @predictions = @input_element.available_predictions(Current.setting.area_code)
    @prediction  = @predictions.find(params[:prediction_id]) rescue @predictions.first
    @comment = Comment.new
    @comment.commentable = @prediction

    render :layout => 'iframe'
  end

  def share
    # Set the locale to nl untill en translations are available
    if english?
      I18n.locale = 'nl'
      flash[:notice] = 'Sorry, this page is only available in dutch'
    end
    @input_element = @prediction.input_element
    @predictions = @input_element.available_predictions('nl') # the area should probably be include inside the url when more then 1 area is available
    @comment = Comment.new
    @comment.commentable = @prediction
    @end_year = 2050
    render :action => 'index'
  end

  def show
    I18n.locale = 'nl'
    @input_element = @prediction.input_element
    @comment = Comment.new
    @comment.commentable = @prediction
    render :layout => false if request.xhr?
  end

  def comment
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id if current_user
    @comment.commentable = @prediction

    respond_to do |format|
      if @comment.save
        Notifier.comment_mail(@comment).deliver

        format.html { redirect_to predictions_path(:input_element_id => @prediction.input_element_id, :prediction_id => @prediction.id),
                        :notice => "Your comment has been added"}
        format.js { }
      else
        format.html { redirect_to predictions_path(:input_element_id => @prediction.input_element_id, :prediction_id => @prediction.id),
                        :error => "Error saving the comment"}
        format.js { page.alert("Error saving the comment! Please try again") }
      end
    end
  end

  private

    def find_input_element
      @input_element = InputElement.find(params[:input_element_id])
    end

    def find_prediction
      @prediction = Prediction.find(params[:id])
    end
end
