class EmberController < ApplicationController
  def player
    signin (current_user || User.create)
  end
end
