class Api::V1::SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:update, :show, :destroy]

  def index
    @subscriptions = if params[:podcast_id]
                       current_user.subscriptions.where(podcast_id: params[:podcast_id])
                     else
                       current_user.subscriptions
                     end
    @podcasts      = @subscriptions.map(&:podcast)
  end

  def create
    @subscription = current_user.subscriptions.create(subscription_params)
  end

  def show
  end

  def update
    if @subscription.update(subscription_params)
      render json: nil
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription.destroy
    render json: nil
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.require(:subscription).permit(:subscription_type, :podcast_id)
    end
end
