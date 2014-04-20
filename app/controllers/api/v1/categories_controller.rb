class Api::V1::CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def index
    @categories = Category.all
  end

  def show
    @podcasts = @category.podcasts.distinct
  end

  private

  def set_category
    @category = Category.find_by_name(params[:id])
  end
end
