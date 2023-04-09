class GroupsController < ApplicationController
  # すべてのアクションの前に、ユーザーがログインしているかどうかを確認する。
  before_action :authenticate_user!
  before_action :ensure_correct_user,only: [:edit, :update]

  def index
    @book = Book.new
    @groups = Group.all
    @user = current_user
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
    @user = User.find(params[:id])
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

  private


  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  # 直接URL入力によるアクセス対策
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

end
