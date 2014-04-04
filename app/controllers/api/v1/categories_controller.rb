class Api::V1::CategoriesController < ApplicationController
  before_action :set_category

  def index
    @categories = Category.all
  end

  def show
  end

  private

  def set_category
    @category = Category.find_by_name(params[:id])
  end
end
