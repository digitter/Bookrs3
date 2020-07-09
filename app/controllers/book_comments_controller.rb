class BookCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])

    # @book_comment = @book.book_comments.new(book_comment_params)
          # => #<BookComment id: nil, user_id: nil, book_id: 16, comment: "", created_at: nil, updated_at: nil>
          # @book.book_comments => #<BookComment id: nil,...> id が nil だと ?!!!!?????? なぜお前が？！

    @book_comment = BookComment.new(book_comment_params)
    @book_comment.book_id = @book.id
          # => #<BookComment id: nil, user_id: nil, book_id: 16, comment: "", created_at: nil, updated_at: nil>
          # @book.book_comments => 普通にDBに保存されたことがあるコメント(book comment)だけ取得してる。id をもつコメント(book comment)。

    @book_comment.user_id = current_user.id
    if @book_comment.save
      flash[:success] = "Comment was successfully created."
      redirect_to book_path(@book)
    else
      # @book_comments = BookComment.where(book_id: @book.id)
          # whereに関してはDBからしかデータを取ってこない。
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
