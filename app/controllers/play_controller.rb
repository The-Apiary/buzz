class PlayController < ApplicationController
  def index
    @podcasts = Podcast.all # TODO: replace with users podcasts
    @episodes = Episode.where(podcast_id: @podcasts.ids).includes :podcast
  end
end
