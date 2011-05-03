class Admin::UserLogsController < Admin::AdminController

  def index
    @user_logs = UserLog.all
  end

  def show
    @user_logs = UserLog.where(:ip => params[:ip])
  end

end
