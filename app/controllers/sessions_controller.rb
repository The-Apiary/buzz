class SessionsController < ApplicationController

  def create
    @remember_me = false

    if id_hash_params.any?
      @user = user_from_id_hash
      @remember_me ||= params[:remember_me]
    elsif facebook_params
      @user = user_from_facebook current_user
      @remember_me ||= request.env['omniauth.params']['remember_me'] == "true"
    else
      @user = nil
    end

    respond_to do |format|
      if @user
        signin @user, @remember_me
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

  def id_hash_params
    params.permit(:id_hash, :remember_me)
  end

  def facebook_params
    params
  end

  # Signs in a user by id_hash
  def user_from_id_hash
    User.find_by_id_hash params[:id_hash]
  end

  def user_from_facebook link_user
    User.from_omniauth(request.env["omniauth.auth"], link_user)
  end
end
