class Api::V1::QueuedEpisodesController < ApplicationController
  respond_to :json

  # return queued episodes
  def index
    respond_with Episode.queued
  end
end
