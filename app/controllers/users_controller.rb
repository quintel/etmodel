class UsersController < ApplicationController
  layout 'pages'
  
  def index
    @user = User.new
    render :action=>"new"
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice] = I18n.t("flash.register")
        format.html { redirect_to(root_url) }
      else
        format.html { render :controller=>"users", :action=>"new" }
      end
    end
  end

  def update
    @user = current_user
    @user.attributes = params[:user]
    @user.save do |result|
      if result
        flash[:notice] = I18n.t("flash.edit_profile")
        format.html { redirect_to(@user) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end
