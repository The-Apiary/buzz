class Api::V1::EpisodesController < ApplicationController
  respond_to :json
  before_action :set_episode, only: [:show, :edit, :update]

  def index
    @episodes = if params[:podcast_id]
                  ember_show params[:podcast_id]
                elsif params[:recently_published]
                  recently_published
                elsif params[:recently_listened]
                  recently_listened
                else
                  all_episodes
                end
  end

  def show
  end

  # Updates or creates a user's episode_data
  def data
    @episode_data = EpisodeData.find_or_initialize_by(
      episode_id: params[:id],
      user_id: current_user.id)
    if @episode_data.update(episode_data_params)
      render json: nil
    else
      render json: @episode_data.errors, status: :unprocessable_entity
    end
  end

  def update
    if @episode.update(episode_params)
      render json: nil
    else
      render json: @episode.errors, status: :unprocessable_entity
    end
  end

  private

  # All episodes for the given podcast
  def podcast_episodes podcast_id
    Podcast.find(podcast_id).episodes
      .includes(:episode_datas)
      .order(publication_date: :desc)
  end

  def recently_published
    current_user.recently_published_episodes
      .includes(:episode_datas)
      .order(publication_date: :desc)
  end

  def recently_listened
    current_user.recently_listened_episodes
  end

  def all_episodes
    current_user.episodes
      .includes(:episode_datas)
      .order(publication_date: :desc)
  end

  def set_episode
    @episode = Episode.find(params[:id])
  end

  def episode_params
    params.require(:episode).permit(:duration)
  end

  def episode_data_params
    params.permit(:is_played, :current_position)
  end
end
