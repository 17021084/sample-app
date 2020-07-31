class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      params[:session][:remember_me] == Settings.form.checkbox ? remember(user) : forget(user)
      flash[:success] = t(".success", username: user.name)
      redirect_to user_path(locale, user)
    else
      flash.now[:danger] = t(".danger")
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = t(".flash")
    redirect_to root_path
  end
end
