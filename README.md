# Bookers コメント機能 実験レポジトリ

### ネストしたルーティング
***
本来 `resource: book_comments` にした方が簡潔だが、
敢えて resources にしてた設計で検証してみた。

```ruby
  resources :books, only: [:index, :show, :edit, :create, :update, :destroy] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  ```

### よって、コメントに関してのルーティングは以下になる。
***
rails routes or http://localhost:3000/rails/info/routes で確認できます。
[画像](/sampleImages/routing.png)

### ルーティングには book_id と id が要求されているので以下のようなlinkが必要となる。
***
app/views/books/show.html.erb
linkの第二引数の `pathの引数` が二つ必要な状態になる。
```ruby
<%= link_to 'Destroy', book_book_comment_path(book_id: @book, id: book_comment.id), class: 'btn-sm btn-danger', method: :delete %>
```

参考: https://stackoverflow.com/questions/25269232/how-do-you-pass-multiple-arguments-to-nested-route-paths-in-rails

### その他の前提知識
***
#### インスタンスの id はDBに保存されるまで nil である !!! (created_at, updated_atについてもnilです)

transaction処理成功後にBookのインスタンスの `id` が `nil` ではなく `17` が付与されている。（created_atもupdated_atも)
[画像](/sampleImages/instance.png)

*rails console(rails c)　で検証できます。

```
User.first
  => #<User id: 1, email: "test@test", name: "test", introduction: nil, profile_image_id: nil, created_at: "2019-12-18 20:49:42", updated_at: "2019-12-18 20:51:59">

book_instance = Book.new(title: 'Ruby on Rails', body: 'webアプリ開発', user_id: i)
  => #<Book id: nil, title: "Ruby on Rails", body: "webアプリ開発", created_at: nil, updated_at: nil, user_id: 1 >

book_instance.save
  => 
   (7.4ms)  begin transaction
  User Load (2.7ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  SQL (2.6ms)  INSERT INTO "books" ("title", "body", "created_at", "updated_at", "user_id") VALUES (?, ?, ?, ?, ?)  [["title", "Ruby on Rails"], ["body", "webアプリ開発"], ["created_at", 2020-07-11 04:50:54 UTC], ["updated_at", 2020-07-11 04:50:54 UTC], ["user_id", 1]]
   (0.8ms)  commit transaction
  => true

book_instance
  => #<Book id: 17, title: "Ruby on Rails", body: "webアプリ開発", created_at: "2020-07-11 04:50:54", updated_at: "2020-07-11 04:50:54", user_id: 1>
```

#### あとはアソシエーションを理解していること

### 質問についてはPull Request 形式で受け付けます。
***

以上の前提知識を踏まえて上でapp/controllers/book_comments_controller.rb内のcreateアクションを参照してください。失敗するパターン1、成功するパターン2の説明を書いておきました。
