class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by(id: params[:followed_id])
    unless @user
      flash[:danger] = "User not found"
      redirect_to users_url
    end
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @rel = Relationship.find_by(id: params[:id])
    unless @rel
      flash[:danger] = "Not found"
      redirect_to users_url
    end
    @user = @rel.followed
    unless @user
      flash[:danger] = "User not found"
      redirect_to users_url
    end
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end   
  end
end
