module Admin
  class TextsController < BaseController
    before_filter :find_text, :only => [:edit, :update, :destroy]
    def index
      @texts = Text.all
    end

    def edit
    end

    def update
      if @text.update_attributes(params[:text])
        flash[:notice] = "Successfully updated text."
        redirect_to admin_texts_path
      else
        render :action => 'edit'
      end
    end

    def new
      @text = Text.new
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

    def destroy
      @text.destroy
      redirect_to admin_texts_path
    end

    private

    def find_text
      @text = Text.find params[:id]
    end
  end
end
