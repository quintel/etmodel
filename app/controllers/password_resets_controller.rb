class PasswordResetsController < ApplicationController
  layout 'form_only'
  before_action :require_no_user
  before_action :load_user_using_perishable_token, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by_email(user_params[:email])
    @user.deliver_password_reset_instructions! if @user

    flash[:notice] = I18n.t("user.forgot_password.instructions")
    redirect_to login_path
  end

  def edit
    @user = User.new
  end

  def update
    @user.password = user_params[:password]
    @user.password_confirmation = user_params[:password_confirmation]

    # Use @user.save_without_session_maintenance instead if you
    # don't want the user to be signed in automatically.
    if @user.save
      flash[:notice] = I18n.t("user.forgot_password.success")
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages.join(', ')
      Rails.logger.info @user.errors.inspect
      render action: :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation
    )
  end

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = I18n.t("user.forgot_password.account_not_found")
      redirect_to root_url
    end
  end

  def require_no_user
    redirect_to root_path if current_user_session
  end
end
