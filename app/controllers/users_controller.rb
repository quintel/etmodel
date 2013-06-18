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

    unless params[:teacher_email].blank?
      teacher = User.where(email: params[:teacher_email]).first
      if teacher
        @user.teacher_id = teacher.id
      else
        @user.errors.add(:teacher_email, t(:teacher_email))
      end
    end

    if @user.save
      redirect_to home_path, :notice => I18n.t("flash.register")
    else
      render :new
    end
  end

  # GET (This is a bit un-REST-ful, but makes it clickable from
  # emails...)
  def unsubscribe
    @user = User.find(params[:id])

    unless @user.hash == params[:h]
      render text: 'invalid link. Cannot unsubscribe.' and return
    end

    @allow_news_changed = @user.allow_news == true
    @user.allow_news = false

    @user.save!
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
