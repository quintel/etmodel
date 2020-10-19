module Admin
  class GeneralUserNotificationsController < BaseController
    before_action :find_notification, only: [:show, :edit, :update, :destroy]

    def index
      @notifications = GeneralUserNotification.all
    end

    def new
      @notification = GeneralUserNotification.new
    end

    def create
      @notification = GeneralUserNotification.new(general_user_notification_parameters)
      if @notification.save
        flash[:notice] = 'Notification was successfully created.'
        redirect_to admin_general_user_notifications_path
      else
        render action: 'new'
      end
    end

    def update
      @notification = GeneralUserNotification.find(params[:id])
      if @notification.update(general_user_notification_parameters)
        flash[:notice] = 'Notification was successfully updated.'
        redirect_to admin_general_user_notifications_path
      else
        render action: "edit"
      end
    end

    def destroy
      if @notification.destroy
        flash[:notice] = "Successfully destroyed notification."
      else
        flash[:error] = "Error while deleting notification."
      end
      redirect_to admin_general_user_notifications_url
    end


    def show
    end

    def edit
    end

    #######
    private
    #######

    def general_user_notification_parameters
      params.require(:general_user_notification).permit!

    end
    def find_notification
      @notification = GeneralUserNotification.find params[:id]
    end
  end
end
