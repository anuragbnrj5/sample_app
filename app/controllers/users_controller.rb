class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find_by(id: params[:id])
    if !@user.nil?
      @microposts = @user.microposts.paginate(page: params[:page])
    else
      flash[:danger] = "User not found"
      redirect_to users_url
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:danger] = "User not found"
      redirect_to root_url
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if !@user.nil?
      if @user.update_attributes(user_params)
        # Handle a successful update.
        flash[:success] = "Profile updated"
        redirect_to @user
      else
        render 'edit'
      end
    else
      flash[:danger] = "User not found"
      redirect_to root_url
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if !@user.nil?
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    else
      flash[:danger] = "User not found"
      redirect_to users_url
    end
  end

  def following
    @title = "Following"
    @user  = User.find_by(id: params[:id])
    if !@user.nil?
      @users = @user.following.paginate(page: params[:page])
      render 'show_follow'
    else
      flash[:danger] = "User not found"
      redirect_to users_url
    end
  end

  def followers
    @title = "Followers"
    @user  = User.find_by(id: params[:id])
    if !@user.nil?
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
    else
      flash[:danger] = "User not found"
      redirect_to users_url
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters
    
    # Confirms the correct user.
    def correct_user
      @user = User.find_by(id: params[:id])
      if !@user.nil?
        if !current_user?(@user)
          flash[:danger] = "Not Authorized"
          redirect_to(root_url)
        end
      else
        flash[:danger] = "User not found"
        redirect_to root_url
      end
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
