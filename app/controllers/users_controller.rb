class UsersController < ApplicationController
    before_action :set_user, only: [:show, :destroy]

    before_action :require_signin, except: [:new, :create]
    
    before_action :require_correct_user, only: [:edit, :update]

    before_action :require_admin, only: [:destroy]

    def index
        @users = User.all
    end

    def show
        @reviews = @user.reviews
        @favorite_movies = @user.favorite_movies
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        return render :new unless @user.save

        session[:user_id] = @user.id
        redirect_to @user, notice: "Thanks for signing up!"
    end

    def edit
    end

    def update
        return render :edit unless @user.update(user_params)

        redirect_to @user, notice: "Account successfully updated!"
    end
    
    def destroy
        @user.destroy
        redirect_to root_url, alert: "Account successfully deleted!"
    end

private
    def set_user
        @user = User.find_by!(username: params[:id])
    end

    def user_params
        params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
    end

    def require_correct_user
        @user = set_user
        redirect_to root_url, alert: "You do not have access to perform this action!" unless current_user?(@user)
    end
end
