class SessionsController < ApplicationController

  def create
    # NOTE: This logs in a user using their id_hash, this method is being
    # replaced with Oauth.
    @user = if params[:id_hash]
              user_from_id_hash
            else
              user_from_facebook current_user
            end

    respond_to do |format|
      if @user
        signin @user
        format.html { redirect_to root_url }
        format.json { render json: :success }
      else
        error = "Could not find user with id '#{params[:id_hash]}'"
        format.html { redirect_to root_url }
        format.json { render json: { error: error }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    signout
    redirect_to root_path
  end

  private

  # Signs in a user by id_hash
  def user_from_id_hash
    User.find_by_id_hash params[:id_hash]
  end

  def user_from_facebook link_user
    User.from_omniauth(request.env["omniauth.auth"], link_user)
  end
end
