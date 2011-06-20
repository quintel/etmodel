module Admin
class UserLogsController < BaseController

  def index
    @user_logs = UserLog.all
  end

  def show
    @user_logs = UserLog.where(:ip => params[:ip])
  end

end
end