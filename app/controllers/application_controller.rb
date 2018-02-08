class ApplicationController < ActionController::Base
  include LayoutHelper
  include Browser

  protect_from_forgery with: :exception

  helper :all
  helper_method :current_user_session, :current_user, :admin?

  before_action :initialize_current
  before_action :locale

  after_action  :teardown_current

  def locale
    # update session if passed
    if params[:locale]
      redirect_params = params.permit(:controller, :action)
      session[:locale] = params[:locale]
      redirect_to(redirect_params) if request.get?
    end

    # set locale based on session or url
    loc =  session[:locale] || get_locale_from_url
    loc = I18n.default_locale unless ['en', 'nl'].include?(loc.to_s)
    I18n.locale = loc
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

  def assign_scaling_attributes(params)
    area = Api::Area.find_by_country_memoized(params[:area_code]) || Current.setting.area

    if area.derived?
      Current.setting.area_scaling = area.scaling.attributes
    end

    if params[:scaling_attribute]
      Current.setting.scaling = Api::Scenario.scaling_from_params(params)
    end
  end

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
