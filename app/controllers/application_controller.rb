class ApplicationController < ActionController::Base
  include LayoutHelper
  include Browser

  protect_from_forgery with: :exception

  helper :all
  helper_method :current_user_session, :current_user, :admin?

  before_action :initialize_current
  before_action :assign_locale

  after_action  :teardown_current

  def assign_locale
    # update session if passed
    if params[:locale].present? &&
        I18n.available_locales.include?(params[:locale].to_sym)
      redirect_params = params.permit(:controller, :action)
      session[:locale] = params[:locale]
      redirect_to(redirect_params) if request.get?
    end

    I18n.locale =
      session[:locale] ||
      http_accept_language.compatible_language_from(I18n.available_locales) ||
      I18n.default_locale
  end

  def ensure_valid_browser
    # check lib/browser.rb
    return if supported_browser?
    flash[:notice] = I18n.t('flash.unsupported_browser').html_safe
  end

protected

  def initialize_current
    Current.session = session

    unless Api::Area.code_exists?(Current.setting.area_code)
      Current.setting.reset!
    end
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
    redirect_back(fallback_location: default_url)
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

  # Internal: Renders a 404 page.
  #
  # thing - An optional noun, describing what thing could not be found. Leave
  #         nil to say "the page cannot be found"
  #
  # For example
  #   render_not_found('scenario') => 'the scenario cannot be found'
  #
  # Returns true.
  def render_not_found(thing = nil)
    content = Rails.root.join('public/404.html').read

    unless thing.nil?
      # Swap out the word "page" for something else, when appropriate.
      document = Nokogiri::HTML.parse(content)
      header = document.at_css('h1')
      header.content = header.content.sub(/\bpage\b/, thing)

      content = document.to_s
    end

    render(
      html: content.html_safe,
      status: :not_found,
      layout: false
    )

    true
  end
end
