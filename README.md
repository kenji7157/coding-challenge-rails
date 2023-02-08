# 環境構築

## 1. Dockerを使った環境構築

### 1.0 前提


- docker・docker-composeコマンドが使用できること

```
$ docker -v
Docker version 20.10.14, build a224086
$ docker-compose -v
docker-compose version 1.29.2, build 5becea4c
```

### 1.1 環境変数ファイルの作成

- `.env.docker`の作成

```
$ cp .env.sample .env.docker
```

- `.env.docker`を修正

```
$ vi .env.docker
POSTGRES_HOST="db"
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="password"
```

### 1.2 Dockerイメージの作成


```
# イメージを作成する
$ docker-compose build --no-cache
```

### 1.3 コンテナの作成・起動

```
# イメージを元にコンテナを作成し、起動する
$ docker-compose up -d

# マイグレーションの実行
$ docker-compose run --rm web bin/rails db:migrate
```

### 1.4 初期データの投入

```
$ docker-compose run --rm web bin/rails provider:import
$ docker-compose run --rm web bin/rails plan:import
$ docker-compose run --rm web bin/rails basic_charge:import
$ docker-compose run --rm web bin/rails commodity_charge:import
```

### 1.5 動作確認

- http://localhost:3000/ にアクセスして画面が開けること
- 上記確認後に、以下を実行しシミュレーション結果が得られていれば環境構築完了

```
$ curl -H "Content-Type: application/json" -X GET -d '{"ampere": 30, "kwh": 120 }' http://localhost:3000/api/v1/plans
```

### 1.6 Tips
・コンテナの停止・開始
```
# コンテナを停止
$ docker-compose stop

# コンテナを開始
$ docker-compose start
```

- コンテナに入る

```
$ docker-compose exec web bash                 
```

## 2. ローカルで環境構築

### 2.0 前提

- postgreDBが入っていること
- ruby 3.1.0が使えること

### 2.1 環境変数ファイルの作成

```
$ cp .env.sample .env.development
```


### 2.2 gemのインストール

```
$ bundle install --path vendor/bundle
```
  
> `--path vendor/bundle`をつけることで、ディレクトリ内のvendor/bundleにgemがインストールされる

### 2.3 データベースの構築

```
$ bin/rails db:create RAILE_ENV=development
Created database 'coding_challenge_rails_development'
Created database 'coding_challenge_rails_test'
```

### 2.4 マイグレーションの実行

```
$ bin/rails db:migrate
```

### 2.5 初期データの投入

```
$ bin/rails provider:import
$ bin/rails plan:import
$ bin/rails basic_charge:import
$ bin/rails commodity_charge:import
```

### 2.6 動作確認 

```
# 開発サーバの起動
$ bin/rails s

# 開発サーバの起動完了後に以下を実行してシミュレーション結果が取得できれば環境構築完了
$ curl -H "Content-Type: application/json" -X GET -d '{"ampere": 30, "kwh": 120 }' http://localhost:3000/api/v1/plans
```