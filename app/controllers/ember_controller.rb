class EmberController < ApplicationController
  def player
    signin User.create unless current_user
  end
end
