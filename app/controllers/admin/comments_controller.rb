module Admin
  class CommentsController < BaseController
    before_filter :find_comment, :only => [:show, :edit, :update, :destroy]
    
    def index
      @comments = Comment.recent_first.page(params[:page]).per(20)
    end
    
    def show
    end
    
    def edit
    end
    
    def update
      if @comment.update_attributes(params[:comment])
        redirect_to admin_comment_path(@comment), :notice => 'Comment updated'
      else
        render :edit
      end
    end
    
    def destroy
      @comment.destroy
      redirect_to admin_comments_path, :notice => "Comment deleted"
    end
    
    private
    
      def find_comment
        @comment = Comment.find(params[:id])
      end
  end
end
