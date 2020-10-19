module Admin
  class UsersController < BaseController
    before_action :find_user, only: [:show, :edit, :update, :destroy]
    def index
      @users = User.all
    end

    def show
    end

    def edit
    end

    def update
      if @user.update(user_parameters)
        redirect_to [:admin, @user], notice: 'User updated'
      else
        render :edit
      end
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_parameters)
      if @user.save
        redirect_to [:admin, @user], notice: 'User added'
      else
        render :new
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: 'User deleted'
    end

    private

      def find_user
        @user = User.find params[:id]
      end

      def user_parameters
        uparams = params.require(:user).permit!

        unless current_user.try(:admin?)
          uparams.delete(:role_id)
        end

        uparams
      end
  end
end
