class GrampostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :new, :edit]
  before_filter :correct_user, only: [:destroy, :edit]

  def show
    @grampost = Grampost.find(params[:id])
  end

  def edit
  end

  def update
    @grampost = Grampost.find(params[:id])
    if @grampost.update_attributes(params[:grampost])
      flash[:success] = "Grampost updated"
      redirect_to @grampost
    else
      render 'edit'
    end
  end

  def index
    @feed_items = Grampost.paginate(page: params[:page])
  end

  def new
    @grampost = current_user.gramposts.new
  end

  def create
    @grampost = current_user.gramposts.build(params[:grampost])
    if @grampost.save
      flash[:success] = "Grampost created!"
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'new'
    end
  end

  def destroy
    @grampost.destroy
    redirect_back_or root_path
  end

  private
    def correct_user
      @grampost = current_user.gramposts.find_by_id(params[:id])
      redirect_to root_path if @grampost.nil?
    end
end
