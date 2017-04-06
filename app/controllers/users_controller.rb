class UsersController < ApplicationController
  layout 'static_page'
  layout 'form_only', only: %w( new create edit update )

  def new
    @user = User.new
  end

  def edit
    if current_user
      @user = User.find(params[:id])
    else
      redirect_to :root
    end
  end

  def create
    @user = User.new(users_parameters)

    if @user.save
      redirect_to root_path, notice: I18n.t("flash.register")
    else
      render :new
    end
  end

  # GET (This is a bit un-REST-ful, but makes it clickable from
  # emails...)
  def unsubscribe
    @user = User.find(params[:id])

    unless @user.md5_hash == params[:h]
      render plain: 'invalid link. Cannot unsubscribe.' and return
    end

    @allow_news_changed = @user.allow_news == true
    @user.allow_news = false

    @user.save!
  end

  def update
    @user = current_user
    if @user.update_attributes(users_parameters)
      redirect_to edit_user_path(@user), notice: I18n.t("flash.edit_profile")
    else
      render :edit
    end
  end

  #######
  private
  #######

  def users_parameters
    params.require(:user).permit(
      :name, :email, :company_school, :allow_news, :teacher_email,
      :password, :password_confirmation
    )
  end
end
