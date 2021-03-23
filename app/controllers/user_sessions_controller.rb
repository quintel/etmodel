class UserSessionsController < ApplicationController
  layout 'form_only'

  def index
    @user_session = UserSession.new
    render action: "new"
  end

  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new

    redirect_signed_in && return if current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(
      params.require(:user_session).permit(:email, :password, :remember_me).to_h
    )

    @user_session.save do |result|
      if result
        redirect_signed_in
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
    reset_session

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end

  private

  def redirect_signed_in
    return_to = session[:return_to] || root_path
    session[:return_to] = nil
    redirect_to(return_to)
  end
end
