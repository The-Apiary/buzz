class Api::V1::AuthenticatedController < ApplicationController
  respond_to :json
  before_action :check_signed_in

  private

  def check_signed_in
    if current_user.nil?
      render json: {error: "login or add 'user_id_hash' argument"},
        status: :unauthorized
    end
  end
end
