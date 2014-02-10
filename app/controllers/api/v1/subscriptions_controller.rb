class Api::V1::SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :destroy]

  # GET /podcasts
  # GET /podcasts.json
  def index
    @subscriptions = current_user.subscriptions
    @podcasts      = current_user.podcasts
  end


  def subscribe
    render json: current_user.subscribe(@podcast)
  end

  def unsubscribe
    render json: current_user.unsubscribe(@podcast)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_podcast
      @subscription = Subscription.find(params[:id])
      @podcast = @subscription.podcast
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def podcast_params
      params.require(:subscription).permit(:podcast)
    end
end
