class FollowingsController < ApplicationController
  before_action :require_logged_in, :find_user, only: :index

  def index
    @title = t "follow.following"
    @users = @user.following.page(params[:page]).per Settings.pagination.users_per_page
    render "users/show_follow"
  end
end
