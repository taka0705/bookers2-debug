class FavoritesController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    # favorite = current_user.favorites.new(book_id: book.id)
    # カリキュラムを参照しながらだと↑の書き方だけど↓の方がわかりやすい
    favorite = Favorite.new(book_id: @book.id,user_id: current_user.id)
    #book_idはカラム名、book.idはBook.find(params[:book_id]).idと同じ意味
    favorite.save
    # redirect_back(fallback_location: root_path)

  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    # redirect_back(fallback_location: root_path)
  end

end

# リダイレクト先を削除したことにより、
# リダイレクト先がないかつJavaScriptリクエストという状況になり、

# createアクション実行後は、create.js.erbファイルを、
# destroyアクション実行後はdestroy.js.erbファイルを探すようになります