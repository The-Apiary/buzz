class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    @user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def login_user user
    session[:user_id] = user.id
    @user = user
  end

  def logout_user
    session[:user_id] = nil
  end
end
