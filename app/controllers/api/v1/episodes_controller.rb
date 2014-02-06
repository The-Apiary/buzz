class Api::V1::EpisodesController < ApplicationController
  respond_to :json
  before_action :set_episode, only: [:show, :edit, :update, :destroy]

  def index
    @episodes = current_user.episodes
      .joins(:episode_datas)
      .order('episodes.publication_date desc')

    @episode_datas = current_user.episode_datas
  end

  def show
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
    params.require(:episode).permit(:title, :link_url, :description, :audio_url, :podcast_id, :episode_data, :duration)
  end
end
