class Admin::QueryTablesController < Admin::AdminController
  def index
    @query_tables = QueryTable.all
  end

  def show
    @query_table = QueryTable.find(params[:id])
  end

  def new
    @query_table = QueryTable.new
  end

  def create
    @query_table = QueryTable.new(params[:query_table])
    if @query_table.save
      flash[:notice] = "Successfully created query table."
      redirect_to [:admin,@query_table]
    else
      render :action => 'new'
    end
  end

  def edit
    @query_table = QueryTable.find(params[:id])
  end

  def update
    @query_table = QueryTable.find(params[:id])
    if @query_table.update_attributes(params[:query_table])
      flash[:notice] = "Successfully updated query table."
      redirect_to [:admin,@query_table]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @query_table = QueryTable.find(params[:id])
    @query_table.destroy
    flash[:notice] = "Successfully destroyed query table."
    redirect_to admin_query_tables_url
  end
end
