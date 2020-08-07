class MicropostsController < ApplicationController
  before_action :require_logged_in, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :new_micropost, only: :create

  def create
    @micropost.image.attach params[:micropost][:image]
    if @micropost.save
      flash[:success] = t "static_pages.home.created"
      redirect_to root_url
    else
      @feed_items = feed_posts
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "users.destroy.delete_post_success"
    else
      flash[:danger] = t "users.destroy.delete_post_fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOSTS_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "users.destroy.delete_post_fail"
    redirect_to root_url
  end

  def new_micropost
    @micropost = current_user.microposts.build micropost_params
  end

  def feed_posts
    current_user.feed.recent_posts.page(params[:page]).per Settings.pagination.posts_per_page
  end
end
