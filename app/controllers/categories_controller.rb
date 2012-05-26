class CategoriesController < ApplicationController
  def show
    if signed_in?
      @category = Category.find(params[:id])
      # TODO(sophia): Figure out how to test without calling Google API.
      # Experiencing over quota errors. Add test cases once enabled.
      # Look into caching with Redis: https://github.com/alexreisner/geocoder
      #@nearby_items = @category.gramposts.near(current_user.zipcode,
      #                                         current_user.search_distance)
      #@feed_items = @nearby_items.paginate(page: params[:page])
      @feed_items = @category.gramposts.paginate(page: params[:page])
    end
  end
end
