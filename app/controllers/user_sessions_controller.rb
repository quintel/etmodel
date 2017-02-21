class UserSessionsController < ApplicationController
  layout 'static_page'

  def index
    @user_session = UserSession.new
    render action: "new"
  end
  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new
    @redirect_to = params[:return_to]

    redirect_to @redirect_to and return if current_user && !@redirect_to.blank?

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(
      params.require(:user_session).permit(:email, :password)
    )

    @user_session.save do |result|
       if result
        flash[:notice] = I18n.t("flash.login")
        if url = session[:return_to]
          session[:return_to] = nil
          redirect_to url
        elsif UserSession.find.user.role.andand.name == "admin"
          redirect_to "/admin"
        else
          redirect_to_back(root_path)
        end
      else
        respond_to do |format|
          format.html { render action: "new"}
          format.xml  { render xml: @user_session }
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
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end
end
