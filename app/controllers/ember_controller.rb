class EmberController < ApplicationController
  def player
    @user ||= User.find_or_create_by id_hash: params[:id_hash]
    login(@user)
  end

  def start
    if current_user
      @user = current_user
    else
      @user = User.create
    end
    redirect_to player_path @user
  end

  def logout
    super
    redirect_to root_path
  end
end
