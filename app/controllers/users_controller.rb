class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @following_users = @user.following_user
    @follower_users = @user.follower_user
    @books = @user.books
    @book = Book.new
  end

  def index
    @user = current_user
    @following_users = @user.following_user
    @follower_users = @user.follower_user
    @users = User.all
    @book = Book.new
  end

  def edit
    @user=User.find(params[:id])
    if @user == current_user
      render :edit
    else
      redirect_to user_path(current_user.id)
    end

  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def follows
    @user = User.find(params[:id])
    @following_users = @user.following_user
    @users = User.all
  end

  def followers
    @user = User.find(params[:id])
    @follower_users = @user.follower_user
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
