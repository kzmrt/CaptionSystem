# CaptionSystem

これは、キャプション情報登録用のアプリケーションです。
権限に応じて以下の処理を行うことができます。
- ユーザ権限：自分のキャプション情報登録、編集、削除、閲覧。
- 管理者権限：全員のキャプション情報登録、編集、削除、閲覧、およびExcel出力。
新規ユーザはSign Up画面から登録することで当該アプリケーションを使用することが出来るようになります。

## 設定

以下のソースを環境に合わせて設定したください。
- config/environments/development.rb
- config/initializers/devise.rb

## 起動方法

Redis と Sidekiqを立ち上げる必要があります。
- Redisの起動
 - $ redis-server
- Sidekiqの起動
 - $ bundle exec sidekiq -C config/sidekiq.yml -e development

## 動作環境

- ruby: 2.5.1
- Rails: 5.2.0
