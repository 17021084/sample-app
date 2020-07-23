class UsersController < ApplicationController
  before_action :find_user, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t(".flash", username: @user.name)
      redirect_to user_path(@user)
    else
      render "new"
    end
  end

  def show; end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t ".flash"
    redirect_to root_path
  end
end
