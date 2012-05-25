class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @feed_items = @category.gramposts.paginate(page: params[:page])
  end
end
