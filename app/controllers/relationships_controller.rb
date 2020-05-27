class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by(id: params[:followed_id])
    if !@user.nil?
      current_user.follow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      flash[:danger] = "User not found"
      redirect_to users_url
    end
  end

  def destroy
    @rel = Relationship.find_by(id: params[:id])
    if !@rel.nil?
      @user = @rel.followed
      if !@user.nil?
        current_user.unfollow(@user)
        respond_to do |format|
          format.html { redirect_to @user }
          format.js
        end
      else
        flash[:danger] = "User not found"
        redirect_to users_url
      end
    else
      flash[:danger] = "Not found"
      redirect_to users_url
    end
  end
end
