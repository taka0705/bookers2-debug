class FavoritesController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    # favorite = current_user.favorites.new(book_id: book.id)
    # カリキュラムを参照しながらだと↑の書き方だけど↓の方がわかりやすい
    favorite = Favorite.new(book_id: book.id,user_id: current_user.id)
    #book_idはカラム名、book.idはBook.find(params[:book_id]).idと同じ意味
    favorite.save
    redirect_back(fallback_location: root_path)
    # redirect_to book_path(book)
    #ここのredirect_toを書き換える必要がある。
    # 同じページに移るようにするという書き方を調べる。
  end

  def destroy
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end

end