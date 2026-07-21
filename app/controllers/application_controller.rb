class ApplicationController < ActionController::Base
  include LayoutHelper

  protect_from_forgery with: :exception

  helper :all
  helper_method :engine_client, :current_user, :admin?
  helper_method :session_access_token

  before_action :current_user
  before_action :initialize_current
  before_action :assign_locale
  before_action :ensure_modern_browser

  after_action  :teardown_current
  after_action  :set_document_policy_header

  rescue_from YModel::RecordNotFound do
    render_not_found
  end

  rescue_from ActiveRecord::RecordNotFound, CanCan::AccessDenied do
    render_not_found
  end

  def assign_locale
    # update session if passed
    if params[:locale].present? &&
        I18n.available_locales.include?(params[:locale].to_sym)
      redirect_params = params.permit(:controller, :action, :tab, :sidebar, :slide)
      session[:locale] = params[:locale]
      redirect_to(redirect_params) if request.get?
    end

    I18n.locale =
      session[:locale] ||
      http_accept_language.compatible_language_from(I18n.available_locales) ||
      I18n.default_locale
  end

  def ensure_modern_browser
    return unless request.get?

    session[:allow_unsupported_browser] = true if params[:allow_unsupported_browser]

    if Browser.new(request.env['HTTP_USER_AGENT']).ie? && !session[:allow_unsupported_browser]
      redirect_to(unsupported_browser_path(location: request.url[request.base_url.length..]))
    end
  end

  protected

  def initialize_current
    Current.session = session

    unless Engine::Area.code_exists?(Current.setting.area_code)
      Current.setting.reset!
    end
  end

  def teardown_current
    Current.teardown_after_request!
  end

  def permission_denied
    flash[:error] = I18n.t("flash.not_allowed")
    store_location
    redirect_to sign_in_path
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = I18n.t("flash.need_login")
      redirect_to sign_in_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def admin?
    identity_user&.admin?
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

  # Returns the Faraday client which should be used to communicate with MyETM. This contains the
  # user authentication token if the user is logged in.
  def my_etm_client
    if (token = session_access_token)
      Identity.http_client(access_token: token)
    else
      Identity.http_client
    end
  end

  # Returns the Faraday client which should be used to communicate with ETEngine (resource server).
  # This contains the user authentication token if the user is logged in.
  def engine_client
    if (token = session_access_token)
      Identity.http_client(access_token: token, resource: true)
    else
      Identity.http_client(resource: true)
    end
  end

  # The bearer token for the current browser session: the shared domain JWT cookie, when present AND
  # still valid (identity_token only decodes an unexpired, correctly-signed cookie).
  #
  # Used for calls that originate on the server (my_etm_client, engine_client), where no browser is
  # involved and so no cookie is sent. It is deliberately NOT handed to the page anymore: the
  # front-end authenticates with the cookie itself, which the browser keeps current, so there is no
  # in-page copy to go stale and nothing to reload the page for when the session refreshes.
  def session_access_token
    request.cookies[Identity.config.session_cookie_name].presence if identity_token
  end

  def current_user
    @current_user ||=
      if identity_token
        User.from_jwt!(identity_token)
      end
  rescue ActiveRecord::RecordNotFound
    # The user has been deleted from the database. This means the user has deleted their account.
    reset_session
    redirect_to root_path
  end

  private

  # Sets the Document-Policy header required for Sentry browser profiling.
  # See: https://docs.sentry.io/platforms/javascript/profiling/
  def set_document_policy_header
    response.headers['Document-Policy'] = 'js-profiling'
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
