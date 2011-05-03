class Admin::GqueriesController < Admin::AdminController
  sortable_attributes :key, :updated_at,:gquery_group_id => "`gquery_group_id`"

  before_filter :deprecated_admin_area_notice

  def index
    sort = params[:sort] ? "`#{params[:sort]}`" : "`gquery_group_id`"
    order = params[:order] == 'ascending' ? "asc" : "desc" 
    @gqueries = Gquery.find(:all, :order =>"#{sort} #{order}")
    @gqueries = @gqueries.select{|q| q.gquery_group_id == params[:group]} if params[:group]
    respond_to do |format|
      format.html { render }
      format.marshal { send_marshal(Gquery.build_gquery_hash, :filename => 'gquery_hash.marshal') }
    end
  end

  def dump
    sort = params[:sort] ? "`#{params[:sort]}`" : "`gquery_group_id`"
    order = params[:order] == 'ascending' ? "asc" : "desc" 
    
    @gqueries = Gquery.order("#{sort} #{order}")    
    @gqueries = @gqueries.contains(params[:search]) if params[:search]
  end

  def test
    @query = params[:query].gsub(/\s/,'') if params[:query].present?
  end

  def show
    find_model
  end

  def edit
    find_model
  end

  def result
    raw_query = params[:id] ? Gquery.find(params[:id]) : (params[:query] ? params[:query] : '')
    @query = Gql::GqueryCleanerParser.clean(raw_query)
    render :partial => 'result'
  end

  def new
    @gquery = Gquery.new
  end

  def update
    @gquery = Gquery.find(params[:id])
    if @gquery.update_attributes(params[:gquery])
      flash[:notice] = "Gquery created"
      redirect_to admin_gquery_url(@gquery)
    else
      flash[:error] = "Save failed!"
      render :action => 'edit'
    end
  end

  def create
    @gquery = Gquery.new(params[:gquery])
    if @gquery.save
      flash[:notice] = "Gquery created"
      redirect_to admin_gquery_url(@gquery)
    else
      render :action => 'new'
    end
  end

  def destroy
    @gquery = Gquery.find(params[:id])
    if @gquery.destroy
      flash[:notice] = "Gquery #{@gquery.name} deleted"
      redirect_to admin_gqueries_url
    else
      flash[:error] = "Gquery #{@gquery.name} not deleted"
      redirect_to admin_gqueries_url
    end
  end

  def find_model
    if params[:version_id]
      @version = Version.find(params[:version_id])
      @gquery = @version.reify
      flash[:notice] = "Revision"
    else
      @gquery = Gquery.find(params[:id])
    end
  end
end
