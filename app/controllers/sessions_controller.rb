class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate params[:session][:password]
      log_in user
      flash[:success] = t(".success", username: user.name)
      redirect_to user_path(locale, user)
    else
      flash.now[:danger] = t(".danger")
      render "new"
    end
  end

  def destroy
    log_out
    flash[:success] = t(".flash")
    redirect_to root_path
  end
end
