module RelationshipsHelper
  def follow_user
    current_user.active_relationships.build
  end

  def unfollow_user
    current_user.active_relationships.find_by followed_id: @user.id
  end
end
