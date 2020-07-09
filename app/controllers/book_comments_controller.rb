class BookCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    # @book.id が 16の場合 (Bookのインスタンスのidが16の場合)
    
    # ● パダーン１: DBに保存されないコメントが `bookインスタンス.book_comments` で取得できてしまう。
      # @book_comment = @book.book_comments.new(book_comment_params)
            # @book_comment (BookCommentのインスタンス) は ...
                  #<BookComment id: nil, user_id: nil, book_id: 16, comment: "", created_at: nil, updated_at: nil>

            # この後の32行目の @book.book_commentsの結果 ...
                  # 空で投稿したはずのインスタンスも取得できてしまう。DBに保存されてないままだが取得できてしまっているのでコメントの id が nil のまま、view に渡ってしまってエラーがでる。

    # ● パターン 2: DBに保存されたコメントだけを `bookインスタンス.book_comments`で取得する。
    @book_comment = BookComment.new(book_comment_params)
    @book_comment.book_id = @book.id
          # @book_comment (BookCommentのインスタンス) は ...
                #<BookComment id: nil, user_id: nil, book_id: 16, comment: "", created_at: nil, updated_at: nil>

          # この後の32行目の @book.book_commentsの結果 ...
               # 普通にDBに保存されたことがあるコメントだけ取得してる。取得した全てのコメントの id は nil ではない。

    @book_comment.user_id = current_user.id
    if @book_comment.save
      flash[:success] = "Comment was successfully created."
      redirect_to book_path(@book)
    else
      # @book_comments = BookComment.where(book_id: @book.id)
          # whereに関してはDBからしかデータを取ってこないので問題ない。 32行目より30行目の方が確実に id が nil ではない、コメントを取得できる。
      @book_comments = @book.book_comments
      render '/books/show'
    end
  end

  def destroy
    @book_comment = BookComment.find(params[:id])
    if @book_comment.user != current_user
      redirect_to redirect_to book_path(params[:book_id])
    end

    @book_comment.destroy
    redirect_to book_path(params[:book_id])
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
