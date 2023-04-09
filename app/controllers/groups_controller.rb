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

  def join
    @group = Group.find(params[:group_id])
    # ↓の記述は@group.usersに、current_userを追加しているということ
    @group.users << current_user
    redirect_to groups_path
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
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

  def destroy
    @group = Group.find(params[:id])
    # current_userは、@group.usersから消されるという記述
    @group.users.delete(current_user)
    redirect_to groups_path
  end
  
  def new_mail
    @group=Group.find(params[:group_id])
  end
  #↓ new_mail.htmlのform_withで入力された値を受け取っている。
  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    ContactMailer.send_mail(@mail_title,@mail_content,group_users).deliver
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
