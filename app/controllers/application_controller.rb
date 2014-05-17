class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    @user ||= User.find_by_id_hash(cookies[:id_hash]) if cookies[:id_hash]
  end

  def signin(user, remember_me=false)
    user.set_last_login # Sets the user's last login time to now.

    # Both session and cookie are used.
    # cookies for permanent login.
    # session because websockets can't use cookies.
    session[:id_hash] = user.id_hash

    if remember_me
      cookies.permanent[:id_hash] = user.id_hash
    else
      cookies[:id_hash] = user.id_hash
    end

    logger.tagged(:signin) {
      logger.info "#{user.id_hash} signed in. rememberd: #{remember_me}"
    }

    @user = user
  end

  def signout
    session.delete(:id_hash)
    cookies.delete(:id_hash)
  end
end
