class Api::V1::EpisodesController < ApplicationController
  respond_to :json
  before_action :set_episode, only: [:show, :edit, :update]

  def index
    @episodes = if params[:podcast_id]
                  Podcast.find(params[:podcast_id]).episodes
                elsif params[:recent]
                  current_user.episodes.where(['publication_date > ?', 1.month.ago]).limit(100)
                else
                  current_user.episodes
                end.includes(:episode_datas).order(publication_date: :desc)
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
