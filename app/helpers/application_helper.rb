module ApplicationHelper
  def current_user
    @user ||= User.find_by_id_hash(cookies[:auth_token]) if cookies[:auth_token]
  end
end
