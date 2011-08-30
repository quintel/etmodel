module Admin
  class InputElementsController < BaseController
    before_filter :find_model, :only => [:show, :edit]

    def index
      @input_elements = InputElement.all
    end


    def new
      @input_element = InputElement.new
      @input_element.build_description
    end

    def create
      @input_element = InputElement.new(params[:input_element])

      if @input_element.save
        flash[:notice] = "InputElement saved"
        redirect_to admin_input_elements_url
      else
        render :action => 'new'
      end
    end

    def update
      @input_element = InputElement.find(params[:id])

      if @input_element.update_attributes(params[:input_element])
        ["nl","en"].each do |l|
          expire_fragment("slider_#{@input_element.id}_#{l}")
        end
        flash[:notice] = "InputElement updated"
        redirect_to admin_input_elements_url
      else
        render :action => 'edit'
      end
    end

    def destroy
      @input_element = InputElement.find(params[:id])
      if @input_element.destroy
        flash[:notice] = "Successfully destroyed input_element."
        redirect_to admin_input_elements_url
      else
        flash[:error] = "Error while deleting slider."
        redirect_to admin_input_elements_url
      end
    end

    def show
    end

    def edit
      @input_element.build_description unless @input_element.description
    end

    private

      def find_model
        if params[:version_id]
          @version = Version.find(params[:version_id])
          @input_element = @version.reify
          flash[:notice] = "Revision"
        else
          @input_element = InputElement.find(params[:id])
        end
      end
  end
end
