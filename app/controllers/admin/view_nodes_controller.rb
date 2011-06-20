module Admin
class ViewNodesController < BaseController
  before_filter :find_model, :only => [:show, :edit, :update, :destroy]

  def index
    @view_nodes = ViewNode.roots
  end

  def new
    @view_node = ViewNode.new(params[:view_node])
  end

  def create
    
    @view_node = ViewNode.build_typed(params[:view_node])
    if @view_node.save
      flash[:notice] = "ViewNode saved"
      redirect_to admin_view_node_url(@view_node.root.id,:tab => params[:tab], :sidebar => params[:sidebar], :slide => params[:slide])
    else
      render :action => 'new'
    end
  end

  def update
    if params[:constraints]
      update_constraints(@view_node,params[:constraints])
    elsif params[:policy_goals]
      update_policy_goals(@view_node,params[:policy_goals])
    else
    
      attrs = "#{params[:type].underscore}_node".to_sym
      if @view_node.update_attributes(params[attrs])
        flash[:notice] = "ViewNode updated"
        redirect_to admin_view_node_url(@view_node.root.id,:tab => params[:tab], :sidebar => params[:sidebar], :slide => params[:slide])
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    if @view_node.destroy
      redirect_to :back
    end
  end


  def show
    @tabs = @view_node.children.order(:position)
    @sidebars = ViewNode.find(params[:tab]).children.order(:position) unless params[:tab].blank? || @tabs.blank?
    @slides = ViewNode.find(params[:sidebar]).children.order(:position) unless params[:sidebar].blank? || @sidebars.blank?
    @elements = ViewNode.find(params[:slide]).children.order(:position) unless params[:slide].blank? || @slides.blank?    
  end

  def edit
  end

  def find_model
    @view_node = ViewNode.find(params[:id])
  end
  
  def update_constraints(view_node,constraints)
    view_node.constraints.delete_all
    constraints.each do |c|
      view_node.constraints << Constraint.find(c)
    end
    redirect_to admin_view_node_url(@view_node.id)
  end
  
  def update_policy_goals(view_node,policy_goals)
    view_node.policy_goals.delete_all
    policy_goals.each do |pg|
      view_node.policy_goals << PolicyGoal.find(pg)
    end
    redirect_to admin_view_node_url(@view_node.id)
  end
end
end