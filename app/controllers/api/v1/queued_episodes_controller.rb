class Api::V1::QueuedEpisodesController < ApplicationController
  respond_to :json
  before_action :set_queue_manager

  # return queued episodes
  def index
    @queued_episodes = current_user.queued_episodes
      .limit(params[:limit])
      .offset(params[:offset])
  end

  def create
    episode = Episode.find params[:queued_episode][:episode_id]
    if params[:queued_episode][:unshift]
      qe = @qm.unshift(episode)
    else
      qe = @qm.push(episode)
    end

    @queued_episode = qe
    render 'show'
  end

  def update
    if params[:queued_episode][:before_episode]
      episode = Episode.find_by_id(params[:queued_episode][:episode_id])
      before = Episode.find_by_id(params[:queued_episode][:before_episode])
      @queued_episode = @qm.add_before episode, before
      render 'show'
    else
    render json: nil, status: :unprocessable_entry
    end
  end

  def destroy
    QueuedEpisode.find(params[:id]).destroy
    render json: nil
  end

  private

  def set_queue_manager
    @qm = QueueManager.new(current_user)
  end
end
