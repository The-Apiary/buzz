class Api::V1::PodcastsController < ApplicationController
  respond_to :json
  before_action :set_podcast, only: [:show, :edit, :update, :destroy, :subscribe, :unsubscribe]

  # GET /podcasts
  # GET /podcasts.json
  def index
    @podcasts = current_user.podcasts.limit(params[:limit]).offset(params[:offset])
  end

  # GET /podcasts/1
  # GET /podcasts/1.json
  def show
    @podcast
  end

  def create
    @podcast = Podcast.find_or_create_by podcast_params
    if @podcast.valid?
      render 'show'
    else
      render json: @podcast.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_podcast
      @podcast = Podcast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def podcast_params
      params.require(:podcast).permit(:feed_url)
    end
end
