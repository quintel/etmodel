module Admin
  class TextsController < BaseController
    before_action :find_text, only: [:edit, :update, :destroy]
    def index
      @texts = Text.all
    end

    def edit
    end

    def update
      if @text.update(text_parameters)
        flash[:notice] = "Successfully updated text."
        redirect_to admin_texts_path
      else
        render action: 'edit'
      end
    end

    def new
      @text = Text.new
    end

    def create
      @text = Text.new(text_parameters)
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

    def text_parameters
      if params[:text]
        params.require(:text).permit!
      end
    end

    def find_text
      @text = Text.find params[:id]
    end
  end
end
