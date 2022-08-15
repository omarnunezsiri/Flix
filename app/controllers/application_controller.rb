class ApplicationController < ActionController::Base
private
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    helper_method :current_user, :current_user?, :current_user_admin?

    def current_user?(user)
        current_user == user
    end

    def current_user_admin?
        current_user && current_user.admin?
    end

    def require_signin
        session[:intended_url] = request.url
        redirect_to signin_url, alert: "Please sign in first!" unless current_user
    end
    
    def require_admin
        redirect_to movies_url, alert: "Unauthorized access!" unless current_user_admin?
    end
end
