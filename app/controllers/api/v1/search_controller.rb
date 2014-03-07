class Api::V1::SearchController < ApplicationController
  def search
    @results = if params[:q]
                 # Basic fuzzy search, will match the passed query anywhere in a string.
                 Podcast.where("title LIKE ?", "%#{params[:q]}%")
               else
                 []
               end
  end
end
