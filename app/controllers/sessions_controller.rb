class SessionsController < ApplicationController

  def create
    # NOTE: This logs in a user using their id_hash, this method is being
    # replaced with Oauth.
    if params[:id_hash]
      signin_id_hash params[:id_hash]
    end
  end

  def destroy
    signout
    redirect_to root_path
  end

  private

  # Signs in a user by id_hash
  def signin_id_hash id_hash
    @user = User.find_by_id_hash params[:id_hash]
    if @user
      signin @user
      render json: :success
    else
      render json: {
               error: "Could not find user with id '#{params[:id_hash]}'"
             },
             status: :unprocessable_entity
    end
  end
end
