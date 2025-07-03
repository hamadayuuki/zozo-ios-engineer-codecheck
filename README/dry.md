# プロジェクトにおけるDRY原則の理解と実践

## 1. はじめに

実践課題において、DRY原則を意識した部分を記載し説明します。

## 2. DRY原則とは

DRYは "Don't Repeat Yourself" の略で、「**繰り返しを避けること**」という原則です。同じ情報やロジックの繰り返しを避け、コードの重複を排除することを目指します。（参考）

### DRY原則のメリット

-   **保守性の向上**: 仕様変更時に修正箇所が少なくなり、ミスを防ぎます。
-   **可読性の向上**: コードがスッキリし、理解しやすくなります。
-   **再利用性の向上**: 共通化されたコードは他の場所でも使えます。
-   **バグの削減**: 重複コードが減ることで、潜在的なバグも減らせます。

## 3. コードにおけるDRY原則の適用例

提供されたコードの中から、特にDRY原則が効果的に適用されている例を挙げます。

### 例1: APIリクエスト処理の共通化

**関連ファイル:**
-   `Data/Request/APIRequestProtocol.swift`
-   `Data/APIClient.swift`
-   `Data/Request/SearchRepositoriesRequest.swift` (および他のリクエスト定義ファイル)

**実践内容:**

1.  **リクエスト定義を共通化 (`APIRequestProtocol.swift`):**
    APIリクエストに必要な共通の要素（ベースURL、パス、HTTPメソッドなど）と、これらから `URLRequest` オブジェクトを生成する共通処理 (`buildURLRequest()`) をプロトコル `APIRequestProtocol` とその拡張機能として定義しています。

    ```swift
    // APIRequestProtocol.swift の抜粋
    protocol APIRequestProtocol {
        associatedtype Response: Decodable

        var baseURL: URL { get }
        var path: String { get }
        var method: HTTPMethod { get }
        // ... 他のプロパティ
    }

    extension APIRequestProtocol {
        func buildURLRequest() -> URLRequest {
            // URLRequestを構築する共通ロジック
            // ...
        }
    }
    ```

    これにより、個別のリクエスト定義（例: `SearchRepositoriesRequest`）は、このプロトコルに準拠し、自身に固有の情報（具体的なパスなど）を定義するだけで済みます。リクエストを組み立てる詳細なロジックは一箇所に集約されます。

2.  **汎用的なAPIクライアント (`APIClient.swift`):**
    `APIClient` クラスは、`APIRequestProtocol` に準拠した任意のリクエストを受け取り、ネットワーク通信、レスポンス処理、エラーハンドリングを行う汎用的な `request()` メソッドを提供しています。

    ```swift
    // APIClient.swift の抜粋
    final class APIClient: APIClientProtocol {
        func request<D: Decodable>(apiRequest: any APIRequestProtocol) async throws -> Result<D, HTTPError> {
            let request = apiRequest.buildURLRequest() // プロトコルの共通実装を利用
            // URLSessionを用いた通信、レスポンス処理、デコード処理
            // ...
        }
    }
    ```

**DRY原則による効果:**

-   **重複の排除**: `URLRequest` の生成ロジックや、`URLSession` を使った通信処理、エラーハンドリングのコードが、各API呼び出し処理ごとに記述されるのを防いでいます。
-   **保守性の向上**: APIのベースURLが変更になった場合や、リクエストの組み立て方に共通の変更が必要になった場合、修正は `APIRequestProtocol` や `APIClient` の一箇所で済みます。
-   **再利用性**: 新しいAPIエンドポイントを追加する際も、`APIRequestProtocol` に準拠した構造体を作成し、`APIClient` の `request()` メソッドを利用するだけで簡単に対応できます。

### 例2: HTTPエラーハンドリングの共通化

**関連ファイル:**
-   `Data/HTTPError.swift`
-   `Data/APIClient.swift`

**実践内容:**

-   `HTTPError.swift` では、API通信で発生しうる様々なHTTPエラーの種別をenumで定義し、それぞれのエラーに対応するユーザーフレンドリーな説明文 (`errorDescription`) も一元管理しています。
-   `APIClient.swift` 内の `errorHandling(statusCode: Int)` 関数では、HTTPステータスコードに基づいて適切な `HTTPError` を返すロジックが集約されています。

**DRY原則による効果:**

-   エラーの定義とエラーメッセージが一箇所にまとまっているため、エラーの種類を追加したり、メッセージを変更したりするのが容易です。
-   APIレスポンスのステータスコードから具体的なエラー型への変換ロジックが `APIClient` に集約されているため、このロジックが複数の場所に散らばることを防いでいます。

