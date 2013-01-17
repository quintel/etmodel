class UsersController < ApplicationController
  layout 'static_page'

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to home_path, :notice => I18n.t("flash.register")
    else
      render :new
    end
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path(@user), :notice => I18n.t("flash.edit_profile")
    else
      render :edit
    end
  end
end
