class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by(email: params[:email])
        
        unless user && user.authenticate(params[:password])
            flash.now[:alert] = "Invalid email/password combination"
            return render :new
        end

        session[:user_id] = user.id
        redirect_to (session[:intended_url] || user), notice: "Welcome back, #{user.name}"

        session[:intended_url] = nil
    end

    def destroy
        session[:user_id] = nil
        redirect_to movies_url, notice: "You're now signed out!"
    end
end
