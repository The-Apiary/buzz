class EmberController < ApplicationController
  def player
    login User.create unless current_user
  end

  def logout
    super
    redirect_to root_path
  end
end
