class Api::V1::QueuedEpisodesController < ApplicationController
  respond_to :json

  # return queued episodes
  def index
    respond_with Episode.queued
  end

  def create
    puts params
    episode = Episode.find params[:queued_episode][:id]
    QueuedEpisode.create(episode: episode)
    render json: true
  end

  def destroy
    puts params
    QueuedEpisode.find_by_episode_id(params[:id]).destroy
    render json: true
  end
end
