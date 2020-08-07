class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :require_logged_in, except: %i(new create)
  before_action :require_same_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.is_activated.page(params[:page]).per Settings.pagination.users_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".active_notify"
      redirect_to root_url
    else
      flash.now[:danger] = t ".danger"
      render :new
    end
  end

  def show
    @microposts = @user.microposts.recent_posts.page(params[:page])
                       .per Settings.pagination.posts_per_page

    redirect_to root_url && return if @user.activated
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".success"
      redirect_to user_path locale, @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".success"
    redirect_to users_path locale
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def require_same_user
    return if current_user? @user

    flash[:danger] = t ".forbidden"
    redirect_to root_path
  end

  def admin_user
    redirect_to root_path locale unless current_user.admin?
  end
end
