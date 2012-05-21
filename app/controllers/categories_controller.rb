class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @feed_items = @category.gramposts.paginate(page: params[:page])
  end
end
