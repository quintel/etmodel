# frozen_string_literal: true

# Controller that handles calls related to the user entity
class UsersController < ApplicationController
  layout 'static_page'
  layout 'form_only', only: %w[new create]

  before_action :require_user, except: %i[new create]

  def new
    @user = User.new
  end

  def edit
    if current_user
      @user = current_user
    else
      redirect_to :root
    end
  end

  def create
    @user = User.new(users_parameters)

    if @user.save
      CreateNewsletterSubscription.call(@user) if @user.allow_news

      notice = { notice: I18n.t('flash.register') }
      redirect_to(session[:return_to], notice) && return if session[:return_to]

      redirect_to root_path, notice
    else
      render :new
    end
  end

  def update
    @user = current_user

    if @user.update(users_parameters)
      update_newsletter_subscription(@user)
      redirect_to edit_user_path, notice: user_update_notice(@user)
    else
      render :edit
    end
  end

  def confirm_delete; end

  def destroy
    confirmation = UserSession.new(
      email: current_user.email,
      password: params[:password]
    )

    unless confirmation.valid?
      @confirm_error = true
      render :confirm_delete

      return
    end

    current_user_session.destroy
    current_user.destroy

    DestroyMailchimpContact.call(current_user)

    redirect_to root_path, notice: I18n.t('flash.account_deleted')
  end

  private

  def require_user
    redirect_to(root_url) unless current_user
  end

  def users_parameters
    params.require(:user).permit(
      :name, :email, :company_school, :allow_news, :teacher_email,
      :password, :password_confirmation
    )
  end

  # Called when the user updates their profile, to sync changes with Mailchimp.
  def update_newsletter_subscription(user)
    if user.allow_news != user.allow_news_before_last_save
      if user.allow_news
        CreateNewsletterSubscription.call(user)
      else
        DestroyNewsletterSubscription.call(user)
      end
    elsif user.email_before_last_save && user.allow_news
      UpdateNewsletterSubscription.call(user)
    end
  end

  # Message shown to the user after updating their account.
  def user_update_notice(user)
    if user.allow_news != user.allow_news_before_last_save
      if user.allow_news
        I18n.t('flash.newsletter_subscribe')
      else
        I18n.t('flash.newsletter_unsubscribe')
      end
    else
      I18n.t('flash.edit_profile')
    end
  end
end
