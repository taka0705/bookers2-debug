class BooksController < ApplicationController

  def show
    @new = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    @following_users = @user.following_user
    @follower_users = @user.follower_user
    # ↑2つは他の場所でも同じ定義をしているので無駄な記述をしないでいい方法があるかを確認

  end

  def index
    @user = current_user
    @following_users = @user.following_user
    @follower_users = @user.follower_user
    # ↑3つは他の場所でも同じ定義をしているので無駄な記述をしないでいい方法があるかを確認
    @book=Book.new
    @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user.id == current_user.id
      render :edit
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
