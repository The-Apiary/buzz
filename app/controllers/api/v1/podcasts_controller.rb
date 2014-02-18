class Api::V1::PodcastsController < ApplicationController
  respond_to :json
  before_action :set_podcast, only: [:show, :edit, :update, :destroy, :subscribe, :unsubscribe]

  # GET /podcasts
  # GET /podcasts.json
  def index
    respond_with current_user.podcasts.limit(params[:limit]).offset(params[:offset])
  end

  # GET /podcasts/1
  # GET /podcasts/1.json
  def show
    @podcast
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
      @podcast = Podcast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def podcast_params
      params.require(:podcast).permit(:title, :image_url, :feed_url)
    end
end
