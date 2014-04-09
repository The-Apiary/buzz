class Api::V1::EpisodesController < ApplicationController
  respond_to :json
  before_action :set_episode, only: [:show, :edit, :update, :destroy]

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
