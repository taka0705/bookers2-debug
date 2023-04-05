class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    # comment = PostComment.new(post_comment_params)
    # comment.user_id = current_user.id
    @comment.book_id = @book.id
    @comment.save
    # redirect_to book_path(book.id)
    render :book_comments
  end

  def destroy
    @book = Book.find(params[:book_id])
    BookComment.find(params[:id]).destroy
    # redirect_to book_path(params[:book_id])
    render :book_comments
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
