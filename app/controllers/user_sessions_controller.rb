class UserSessionsController < ApplicationController
  layout 'pages'
  def index
    @user_session = UserSession.new
    render :action=>"new"
  end
  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new
    @redirect_to = params[:redirect_to]
    raise HTTPStatus::Forbidden if !@redirect_to.blank? && !valid_redirect?(@redirect_to)
    redirect_to @redirect_to and return if !current_user.nil? && !@redirect_to.blank?

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
       if result
        flash[:notice] = I18n.t("flash.login")
        if valid_redirect?(params[:redirect_to])
            redirect_to params[:redirect_to]
        elsif UserSession.find.user.role.andand.name == "admin"
          redirect_to "/admin"
        else
          begin
            redirect_to_back
          rescue ActionController::RedirectBackError => e
            redirect_to(root_url)
          end
        end
      else
        respond_to do |format|
          format.html { render :action => "new"}
          format.xml  { render :xml => @user_session }
        end
      end
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    @user_session.destroy if @user_session

    respond_to do |format|
      flash[:notice] = I18n.t("flash.logout")
      format.html { redirect_to(root_url) }
      format.xml  { head :ok }
    end
  end
  
  private 
  
  # TODO better check for invalid data
  def valid_redirect?(redirect)
    !redirect.blank? && !redirect.include?('http://')
  end
end
