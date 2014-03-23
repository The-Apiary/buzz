class EmberController < ApplicationController
  def player
    login_user User.create unless current_user
  end

  def login
    @user = User.find_by_id_hash params[:id_hash]
    if @user
      login_user @user
      render json: :success
    else
      render json: { error: "Could not find user with id '#{params[:id_hash]}'" },
                     status: :unprocessable_entity
    end
  end

  def logout
    logout_user
    redirect_to root_path
  end
end
