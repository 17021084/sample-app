class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :require_logged_in, except: %i(new create)
  before_action :require_same_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.pagination.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t ".flash", username: @user.name
      redirect_to user_path @user
    else
      render :new
    end
  end

  def show; end

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

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".flash"
    redirect_to root_path
  end

  def require_logged_in
    return if logged_in?

    store_location
    flash[:danger] = t ".unauthorized"
    redirect_to login_path locale
  end

  def require_same_user
    @user = User.find_by id: params[:id]
    return if current_user? @user

    flash[:danger] = t ".forbidden"
    redirect_to root_path
  end

  def admin_user
    redirect_to root_path locale unless current_user.admin?
  end
end
