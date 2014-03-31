class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    @user ||= User.find_by_id_hash(cookies[:auth_token]) if cookies[:auth_token]
  end

  def signin(user, remember_me=false)
    user.login # Sets the user's last login time to now.

    if remember_me
      cookies.permanent[:auth_token] = user.id_hash
    else
      cookies[:auth_token] = user.id_hash
    end

    @user = user
  end

  def signout
    cookies.delete(:auth_token)
  end
end
