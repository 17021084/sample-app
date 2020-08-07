class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  def require_logged_in
    return if logged_in?

    store_location
    flash[:danger] = t ".unauthorized"
    redirect_to login_path locale
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".flash"
    redirect_to root_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
