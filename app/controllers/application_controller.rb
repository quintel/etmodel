class ApplicationController < ActionController::Base
  include LayoutHelper
  include Browser

  helper :all
  helper_method :current_user_session, :current_user, :admin?

  before_filter :initialize_current
  before_filter :locale
  before_filter :export_i18n_messages
  after_filter :teardown_current

  def locale
    # update session if passed
    session[:locale] = params[:locale] if params[:locale]
    # set locale based on session or url
    I18n.locale =  session[:locale] || get_locale_from_url
  end

  def get_locale_from_url
    # set locale based on host or default
    request.host.split(".").last == 'nl' ? 'nl' : I18n.default_locale
  end

  def ensure_valid_browser
    # check lib/browser.rb
    flash[:notice] = I18n.t 'flash.unsupported_browser' unless supported_browser?
  end

protected

  def initialize_current
    Current.session = session
  end

  def teardown_current
    Current.teardown_after_request!
  end

  def permission_denied
    flash[:error] = I18n.t("flash.not_allowed")
    store_location
    redirect_to login_path
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = I18n.t("flash.need_login")
      redirect_to login_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def admin?
    current_user.try :admin?
  end

  def restrict_to_admin
    if admin?
      true
    else
      permission_denied
      false
    end
  end

  # redirect_to :back fails fairly often. This is safer
  def redirect_to_back(default_url = root_path)
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to default_url
  end

private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def export_i18n_messages
    SimplesIdeias::I18n.export! if Rails.env.development?
  end
end
