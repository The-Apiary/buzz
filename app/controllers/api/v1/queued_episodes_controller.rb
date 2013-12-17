class Api::V1::QueuedEpisodesController < ApplicationController
  respond_to :json

  # return queued episodes
  def index
    respond_with Episode.queued
  end

  def create
    puts params
    episode = Episode.find params[:queued_episode][:id]
    render json: QueuedEpisode.create(episode: episode)
  end

  def destroy
    puts params
    render json: QueuedEpisode.find_by_episode_id(params[:id]).destroy
  end
end
