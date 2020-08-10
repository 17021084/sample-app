class RelationshipsController < ApplicationController
  before_action :require_logged_in
  before_action :find_create_relationship, only: :create
  before_action :find_destroy_relationship, only: :destroy

  def create
    if @user.blank?
      flash[:danger] = t ".user_not_exist"
      redirect_to root_path
    else
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to user_path locale, @user}
        format.js
      end
    end
  end

  def destroy
    if @user.blank?
      flash[:danger] = t ".user_not_exist"
      redirect_to root_path
    else
      current_user.unfollow @user
      respond_to do |format|
        format.html{redirect_to user_path locale, @user}
        format.js
      end
    end
  end

  private

  def find_create_relationship
    @user = User.find_by id: params[:followed_id]
  end

  def find_destroy_relationship
    @user = Relationship.find(params[:id]).followed
  end
end
