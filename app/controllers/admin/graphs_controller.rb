class Admin::GraphsController < Admin::AdminController

  before_filter :deprecated_admin_area_notice

  before_filter :load_graph, :only => [:show, :groups, :edit, :destroy, :updated]

  def chart
    render :layout => false
  end

  def index
    @graphs = Graph.find(:all, :order=>'id desc')
  end

  def checks

  end

  def show
    # this fails right now, turned of temporarily 
    # if @graph
    #   Current.gql = @graph.gql
    # end
    if params[:compare_to] and @compare_graph = Graph.find(params[:compare_to])
      @compare_graph.to_qernel.calculate
    end
    respond_to do |format|
      format.json do
        render :json => Current.gql.present.converters.inject({}) {|hsh,c| hsh.merge c.id => {:demand => ((c.proxy.demand / 1000000).round(1) rescue nil)} }
      end
      format.html    { render }
      format.marshal { send_marshal(Gql::Gql.new(@graph)) }
    end
  end

  def groups
    if @graph
      Current.gql = @graph.gql
    end
  end

  def create
# QUESTION sebi we don't want to try to support csv import right?
# REPLY ed Yes we do want to support csv import. There will be two modes:
#          - import blueprint from CSV (creates a new blueprint)
#          - import dataset from CSV (for a specific blueprint)
# but this actually happens in #import
    render :text => 'Sorry, csv import is no longer supported. A GUI is coming soon.'
  end

  def destroy
    if @graph.destroy
      flash[:notice] = 'Graph deleted'
      redirect_to :back
    end
  end

  ##
  # Expects a zip file with a folder (folder name = region_code) for each country/region.
  #
  #
  def import
    raise 'version not defined' if params[:version].blank?
    require 'zip/zip'
    version = params[:version]
    file = params[:zip_file]
    version_path = "import/#{version}"

    Zip::ZipFile.open(file.tempfile) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(version_path, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
    end

    countries = Dir.entries(version_path).reject{|p| p.include?('MACOS')}.select{|country_dir|
      # check that file is directory. excluding: "." and ".."
      File.directory?("#{version_path}/#{country_dir}") and !country_dir.match(/^\./)
    }

    csv_import = CsvImport.new(version, countries.first)
    blueprint = csv_import.create_blueprint
    blueprint.update_attribute :description, params[:description]

    countries.each do |country|
      csv_import = CsvImport.new(version, country)
      dataset = csv_import.create_dataset(blueprint.id, country)
      Graph.create :blueprint_id => blueprint.id, :dataset_id => dataset.id
    end
    redirect_to admin_graphs_url
  end
end
