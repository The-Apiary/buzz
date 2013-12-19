class Api::V1::EpisodesController < ApplicationController
  respond_to :json
  before_action :set_episode, only: [:show, :edit, :update, :destroy]

  # GET /episodes
  # GET /episodes.json
  def index
    respond_with Episode.all.includes(:episode_data).limit(params[:limit]).offset(params[:offset])
  end

  # GET /episodes/1
  # GET /episodes/1.json
  def show
    respond_with @episode
  end

  # PATCH/PUT /episodes/1
  # PATCH/PUT /episodes/1.json
  def update

    # I hate this TODO: fix this
    success = @episode.episode_data.nil? ? @episode.create_episode_data(episode_data_params) : @episode.episode_data.update(episode_data_params)
    logger.tagged('update episode data') {
      logger.tagged(@episode.title) {
        if success
          logger.info "set position: #{@episode.episode_data.current_position}"
        else
          logger.error "failed to set current_position"
        end
      }
    }

    if @episode.update(episode_params)
      render json: nil
    else
      render json: @episode.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      params.require(:episode).permit(:title, :link_url, :description, :audio_url, :podcast_id, :episode_data, :duration)
    end

    def episode_data_params
      params.require(:episode).permit(:is_played, :current_position)
    end
end
