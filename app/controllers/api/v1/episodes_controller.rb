class Api::V1::EpisodesController < ApplicationController
  respond_to :json
  before_action :set_episode, only: [:show, :edit, :update, :destroy]

  def index
    @episodes = current_user.episodes
      .includes(:episode_datas)
      .order(publication_date: :desc)

    @episode_datas = current_user.episode_datas
  end

  def show
  end

  def update
    # The front end treats episode, and episode_data as one combined model,
    # so this controller has to seperate episode_data from episode attributes.
    update_episode_data()

    # NOTE: This action will return true even if updating episode_data failed.
    # TODO: Add any episode_data errors to @episode errors.
    if @episode.update(episode_params)
      render json: nil
    else
      render json: @episode.errors, status: :unprocessable_entity
    end
  end

  private

  def update_episode_data
    episode_data = EpisodeData.find_or_create_by user: current_user, episode: @episode
    logger.tagged('update episode data') {
      logger.tagged(@episode.title) {
        if episode_data.update(episode_data_params)
          logger.info "set position: #{episode_data.current_position}"
        else
          logger.error "failed to set current_position"
        end
      }
    }
    return episode_data
  end

  def set_episode
    @episode = Episode.find(params[:id])
  end

  def episode_params
    params.require(:episode).permit(:title, :link_url, :description, :audio_url, :podcast_id, :episode_data, :duration)
  end

  def episode_data_params
    params.require(:episode).permit(:is_played, :current_position)
  end
end
