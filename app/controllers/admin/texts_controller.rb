module Admin
  class TextsController < BaseController
    def index
      @texts = Text.all
    end

    def edit
      @text = Text.find(params[:id])
    end

    def update
      @text = Text.find(params[:id])
      if @text.update_attributes(params[:text])
        flash[:notice] = "Successfully updated text."
        redirect_to admin_texts_path
      else
        render :action => 'edit'
      end
    end

    def new
      @text = Text.new()
    end

    def create
      @text = Text.new(params[:text])
      if @text.save
        flash[:notice] = "Successfully created a new text."
        redirect_to admin_texts_path
      else
        render :new
      end
    end
  end
end
