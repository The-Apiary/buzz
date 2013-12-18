class Api::V1::QueuedEpisodesController < ApplicationController
  respond_to :json

  # return queued episodes
  def index
    respond_with QueuedEpisode.all
  end

  def create
    episode = Episode.find params[:queued_episode][:episode_id]
    render json: QueuedEpisode.create(episode: episode)
  end

  def destroy
    QueuedEpisode.find(params[:id]).destroy
    # FIXME: What does Ember Data want in repsonse?
    render json: true
  end
end
