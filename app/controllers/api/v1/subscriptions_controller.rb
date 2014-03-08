class Api::V1::SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :destroy]

  # GET /podcasts
  # GET /podcasts.json
  def index
    #@subscriptions = current_user.subscriptions
    @subscriptions = if params[:podcast_id]
                       current_user.subscriptions.where(podcast_id: params[:podcast_id])
                     else
                       current_user.subscriptions
                     end
    @podcasts      = @subscriptions.map(&:podcast)
  end

  def create
    @subscription = current_user.subscriptions.create(podcast_params)

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_podcast
      @subscription = Subscription.find(params[:id])
      @podcast = @subscription.podcast
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def podcast_params
      params.require(:subscription).permit(:podcast_id)
    end
end
