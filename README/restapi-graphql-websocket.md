````markdown
# RestAPI / GraphQL / WebSocket 比較
 
## RestAPI

```python
# Flask による簡単な WebAPI（REST API）の例
from flask import Flask, request, jsonify

app = Flask(__name__)

countries = [
    {"id": 1, "name": "Thailand", "capital": "Bangkok"},
    {"id": 2, "name": "Australia", "capital": "Canberra"},
]

@app.get("/countries")
def get_countries():
    return jsonify(countries)

@app.post("/countries")
def add_country():
    country = request.get_json()
    country["id"] = max(c["id"] for c in countries) + 1
    countries.append(country)
    return country, 201

if __name__ == "__main__":
    app.run(debug=True)
````

* HTTP GET / POST を使って `users` や `countries` といったリソースにアクセス。
* JSON 形式で送受信する。

---

## ■ GraphQL とは

```python
# Python で Graphene + Flask による簡単な GraphQL サーバー
import graphene
from flask import Flask
from flask_graphql import GraphQLView

class Query(graphene.ObjectType):
    hello = graphene.String(name=graphene.String(default_value="World"))

    def resolve_hello(self, info, name):
        return f"Hello {name}"

schema = graphene.Schema(query=Query)

app = Flask(__name__)
app.add_url_rule(
    "/graphql",
    view_func=GraphQLView.as_view("graphql", schema=schema, graphiql=True)
)

if __name__ == "__main__":
    app.run(debug=True)
```

* 単一の `/graphql` エンドポイントにクエリを POST で送信。
* クライアントが必要なデータ構造を宣言でき、「型付きスキーマ」「Query / Mutation / Subscription」などを仕様として提供します。

---

## ■ WebSocket とは

```python
# FastAPI を用いた WebSocket サーバーの例
from fastapi import FastAPI, WebSocket

app = FastAPI()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        await websocket.send_text(f"Message text was: {data}")
```

* HTTP のハンドシェイクで接続を確立し、一度接続した後は双方向・リアルタイム通信が可能。
* チャットや通知、ライブフィードなどに適している。GitHub のPRレビュー画面にも使われており、自分以外の変更が即時反映されるのは WebSocket のおかげ。

---

## RestAPI と GraphQL の違い

| 項目        | RestAPI              | GraphQL（API 言語仕様）                     |
| --------- | ------------------------- | ------------------------------------- |
| エンドポイント構成 | リソース単位に複数（例：`/countries`） | 単一エンドポイント `/graphql` に全クエリを集中         |
| データ取得の柔軟性 | 固定構造、大量取得や不足取得の可能性        | クエリで必要なフィールド指定、過不足防止                  |
| 型とスキーマ    | OpenAPI など別管理が必要          | SDL により型とスキーマを仕様として定義                 |
| バージョニング   | URL に `v1/v2` など含める必要あり   | スキーマ拡張 + `@deprecated` によりバージョン不要     |
| 操作種別      | GET / POST / PUT / DELETE | Query / Mutation / Subscription |

* RestAPI はリソース指向の設計、GraphQL はクライアント主導の柔軟なクエリ設計が特徴です。

---

## RestAPI と WebSocket の違い

| 観点      | RestAPI   | WebSocket                   |
| ------- | ------------------- | --------------------------- |
| 通信モデル   | 一方向：リクエスト → レスポンスのみ | 双方向通信：クライアント ⇄ サーバ          |
| 接続      | リクエストごとに接続確立、都度切断   | 一度接続すれば継続（ステートフル）           |
| リアルタイム性 | ポーリング／頻繁なアクセスが必要    | 即時性あり、サーバプッシュでリアルタイム対応      |
| オーバーヘッド | HTTP ヘッダーなどで比較的大きい  | 軽量フレーム形式で省リソース（handshake 後） |

* WebAPI はステートレスな CRUD に向いており、WebSocket は状態維持したリアルタイム通信に特化しています。

---

## まとめ

* WebAPI（REST）：典型的な HTTP ベースのリソース指向 API。Flask などで簡単に実装可能。
* GraphQL：API 向けクエリ言語仕様。型システム、柔軟なクエリ、単一エンドポイント設計。
* WebSocket：通信プロトコル。双方向・低遅延通信で Subscription やリアルタイム機能と相性抜群。