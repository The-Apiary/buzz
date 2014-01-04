class EmberController < ApplicationController
  def player
    @user ||= User.find_by_id_hash(params[:id_hash])
    login(@user)
  end

  def start
    @user = User.create
    redirect_to player_path(@user, id_hash: @user.id_hash)
  end
end
