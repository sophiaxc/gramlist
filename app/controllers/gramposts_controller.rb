class GrampostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: :destroy

  def create
    @grampost = current_user.gramposts.build(params[:grampost])
    if @grampost.save
      flash[:success] = "Grampost created!"
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @grampost.destroy
    redirect_back_or root_path
  end

  def index
  end

  private
    def correct_user
      @grampost = current_user.gramposts.find_by_id(params[:id])
      redirect_to root_path if @grampost.nil?
    end
end
