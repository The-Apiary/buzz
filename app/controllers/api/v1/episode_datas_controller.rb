class Api::V1::EpisodeDatasController < ApplicationController
  respond_to :json
  before_action :set_episode_data, only: [:show, :edit, :update, :destroy]

  def index
    @episode_datas = current_user.episode_datas.limit(params[:limit]).offset(params[:offset])
  end

  def show
  end

  def create
    render json: current_user.episode_data.create(episode_data_params)
  end

  def update
    if @episode_data.update(episode_data_params)
      render json: nil
    else
      render json: @episode_data.errors, status: :unprocessable_entity
    end
  end

  private

  def set_episode_data
    @episode_data = EpisodeData.find(params[:id])
  end

  def episode_data_params
    params.require(:episode_data).permit(:episode_id, :is_played, :current_position)
  end
end
