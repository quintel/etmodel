class Admin::ConverterDatasController < Admin::AdminController
  before_filter :deprecated_admin_area_notice

  before_filter :load_graph, :find_qernel_graph, :find_converter_data


  def show
    
  end
  
  
  def edit
  end
  
  def update
    @converter_data.update_attributes(params[:converter_data])
    redirect_to admin_graph_path(@g)
  end

  private

  def find_converter_data
    @converter_data = @g.dataset.converter_datas.find_by_name(@converter.name)
  end
  
end
