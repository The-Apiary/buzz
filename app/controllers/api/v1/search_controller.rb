class Api::V1::SearchController < ApplicationController
  def search
    @results = if params[:q]
      # Basic fuzzy search, will match the passed query anywhere in a string.
      (Podcast.where("lower(title) LIKE lower(?)", "%#{params[:q]}%") +
      Podcast.where(feed_url: params[:q]) +
      Podcast.where("lower(description) LIKE lower(?)", "%#{params[:q]}%"))
        .uniq
    else
      []
    end
  end
end
