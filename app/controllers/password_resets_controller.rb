class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".info"
      redirect_to root_path locale
    else
      flash.now[:danger] = t ".danger"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t(".empty")
      render :edit
    elsif @user.update user_params.merge reset_digest: nil
      reset_password @user
    else
      flash.now[:danger] = t ".fail"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::RESET_PASSWORD_PARAMS
  end

  def find_user
    @user = User.find_by email: params[:email].downcase
    return if @user

    flash[:errors] = t ".flash"
    redirect_to new_password_reset_url
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash[:danger] = t ".forbidden"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".expire"
    redirect_to new_password_reset_url
  end

  def reset_password user
    log_in user
    flash[:success] = t ".reset"
    redirect_to user_path locale, user
  end
end
