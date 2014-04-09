class EmberController < ApplicationController
  def player
    if current_user
      # Users last login date must be kept up tp date, but don't set it every time they login
      current_user.set_last_login if current_user.last_login < 1.day.ago
    else
      signin User.create
    end
  end
end
