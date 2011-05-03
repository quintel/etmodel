class Admin::ConvertersController  < Admin::AdminController
  before_filter :deprecated_admin_area_notice

  before_filter :load_graph, :find_qernel_graph, :find_converter
  
  def show
    respond_to do |format|
      format.html {
        render :layout => true
      }
      format.png {
        path = "images/converter_#{Time.now.to_i}"
        @converter.to_image(params[:depth].andand.to_i || 3, "public/#{path}")
        redirect_to "/#{path}.png"
      }
    end
  end


  def edit
    render :text => "Does not work anymore"
  end

  def update
    render :text => "Does not work anymore"
  end
  
  private
  
  def find_converter
    @converter = @qernel_graph.converter(params[:id].to_i)
    @converter_present = @graph.gql.present.converter(params[:id].to_i)
    @converter_future  = @graph.gql.future.converter(params[:id].to_i)
  end


end
