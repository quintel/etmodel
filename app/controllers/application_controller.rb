class ApplicationController < ActionController::Base
  include LayoutHelper

  helper :all
  helper_method :current_user_session, :current_user, :admin?

  # TODO refactor move the hooks and corresponding actions into a "concern"
  before_filter :initialize_current
  before_filter :locale

  if Rails.env.test?
    after_filter :assign_current_for_inspection_in_tests
  end
  after_filter :teardown_current
  before_filter :export_i18n_messages

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
    unless ALLOWED_BROWSERS.include?(browser)
      #TODO: put text in translation files and translate!
      flash[:notice] = "Your browser is not completely supported." +
        "<small><a href='/browser_support'>more information</a></small>"
    end
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
  def assign_current_for_inspection_in_tests
    @current = Current
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  # TODO refactor into lib/browser.rb (seb 2010-10-11)
  def browser
    user_agent = request.env['HTTP_USER_AGENT']
    return 'firefox' if user_agent =~ /Firefox/
    return 'chrome' if user_agent =~ /Chrome/
    return 'safari' if user_agent =~ /Safari/
    return 'opera' if user_agent =~ /Opera/
    return 'ie9' if user_agent =~ /MSIE 9/
    return 'ie8' if user_agent =~ /MSIE 8/
    return 'ie7' if user_agent =~ /MSIE 7/
    return 'ie6' if user_agent =~ /MSIE 6/
  end

  def export_i18n_messages
    SimplesIdeias::I18n.export! if Rails.env.development?
  end
end
