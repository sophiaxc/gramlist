class StaticPagesController < ApplicationController
  def home
    if signed_in?
      # TODO(sophia): Figure out how to test without calling Google API.
      # Experiencing over quota errors. Add test cases once enabled.
      # Look into caching with Redis: https://github.com/alexreisner/geocoder
      @nearby_items = current_user.feed.near(current_user.zipcode,
                                             current_user.search_distance)
      @feed_items = @nearby_items.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
