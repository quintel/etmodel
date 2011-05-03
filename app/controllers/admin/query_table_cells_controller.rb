class Admin::QueryTableCellsController < Admin::AdminController

  def new
    @query_table_cell = QueryTableCell.new(
      :column => params[:column],
      :row => params[:row],
      :query_table_id => params[:query_table_id]
    )
    render :layout => false
  end

  def create
    @query_table_cell = QueryTableCell.new(params[:query_table_cell])
    if @query_table_cell.save
      flash[:notice] = "Successfully created query table."
      redirect_to [:admin,@query_table_cell.query_table]
    else
      render :action => 'new'
    end
  end

  def edit
    @query_table_cell = QueryTableCell.find(params[:id])
    render :layout => false
  end

  def update
    @query_table_cell = QueryTableCell.find(params[:id])
    if @query_table_cell.update_attributes(params[:query_table_cell])
      flash[:notice] = "Successfully updated query table."
      redirect_to [:admin,@query_table_cell.query_table]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @query_table_cell = QueryTableCell.find(params[:id])
    @query_table_cell.destroy
    flash[:notice] = "Successfully destroyed query table."
    redirect_to [:admin,@query_table_cell.query_table]
  end
end
