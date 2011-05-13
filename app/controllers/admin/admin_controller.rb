class Admin::AdminController < ApplicationController
  layout 'admin'
  before_filter :restrict_to_admin

  # This is to remind the analysts to start using the new data interface
  #
  def deprecated_admin_area_notice
    flash[:error] = "This area is deprecated and will soon be deactivated. You can find it in the new data tool at /data"
  end

  ##
  # Marshals the object and sends it as a file to the user.
  #
  def send_marshal(object, options = {})
    options[:filename] ||= [
      object.class.name.underscore,
      (object.respond_to?(:id) ? object.id : nil),
      'marshal' 
    ].compact.join('.')

    send_data(Marshal.dump(object), :filename => options[:filename], :disposition => 'attachment')
  end


  ##
  # Loads selected graph into @graph and Current.graph
  # Use params[:graph_id] if exists, otherwise params[:id]
  #
  def load_graph
    @graph = Graph.find(params[:graph_id] || params[:id])
    Current.graph = @graph
  end

  ##
  # Sets @qernel_graph to 
  #
  def find_qernel_graph
    raise "@graph is undefined. Probably forgot to add before_filter :load_graph" unless @graph
    @qernel_graph = (params[:graph] == 'future') ? @graph.gql.future : @graph.gql.present
  end
end
