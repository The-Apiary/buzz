class Api::V1::QueuedEpisodesController < ApplicationController
  respond_to :json

  # return queued episodes
  def index
    respond_with current_user.queued_episodes.limit(params[:limit]).offset(params[:offset])
  end

  def create
    episode = Episode.find params[:queued_episode][:episode_id]
    render json: current_user.queued_episodes.create(episode: episode)
  end

  def destroy
    QueuedEpisode.find(params[:id]).destroy
    render json: nil
  end
end
