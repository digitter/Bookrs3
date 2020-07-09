# Bookers コメント機能 実験レポジトリ

### ネストしたルーティング
本来 resource book_commentにした方が簡潔だが、
敢えて resources にしてた設計で検証してみた。

```ruby
  resources :books, only: [:index, :show, :edit, :create, :update, :destroy] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  ```

### コメントに関してのルーティングは以下になる。
rails routes or http://localhost:3000/rails/info/routes で確認できます。
[画像](/sampleImages/routing.png)

### ルーティングには book_id と id が要求されているので以下のようなlinkになる。
app/views/books/show.html.erb
linkの引数が二つの状態になる。
```ruby
<%= link_to 'Destroy', book_book_comment_path(book_id: @book, id: book_comment.id), class: 'btn-sm btn-danger', method: :delete %>
```

### その他の前提知識
#### インスタンスの id はDBに保存されるまで nil である !!!

commit transactionと書いてある後にBookのインスタンスの `id` が `nil` ではなく `17` が付与されている。
[画像](/sampleImages/instance.png)

*rails console(rails c)　で検証できます。


### 質問についてはPull Request 形式で受け付けます。
