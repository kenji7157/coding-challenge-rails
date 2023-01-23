## 環境構築

### 前提

- postgreDBが入っていること
- ruby 3.1.0が使えること
- etc

### gemのインストール

```
# bundle install --path vendor/bundle
```
  
> `--path vendor/bundle`をつけることで、ディレクトリ内のvendor/bundleにgemがインストールされる

### データベースの構築

```
$ bundle exec rake db:create RAILE_ENV=development
Created database 'coding_challenge_rails_development'
Created database 'coding_challenge_rails_test'
```

### マイグレーションの実行

```
bin/rails db:migrate
```

### 初期データの投入

```
$ bin/rails provider:import
$ bin/rails plan:import
$ bin/rails basic_charge:import
$ bin/rails commodity_charge:import
```

### 開発サーバの起動

```
$ bin/rails s
```