module CurrentUser
  def current_user
    hash_id = cookies[:auth_token] || params[:user_id_hash]
    @user ||= User.find_by_id_hash(hash_id) if hash_id
  end
end

module ApplicationHelper
  include CurrentUser
end

