# GitHub APIリクエストにおけるURLの構成要素

実装したコードでGitHub APIを呼び出し、Repositoryのリストを取得する際に用いられるURLの構成要素について解説します。

## 1. URLの基本構成要素

一般的に、Web APIにアクセスするためのURLは、以下の主要な要素から構成されます。

-   **スキーム (Scheme)**: 通信プロトコルを指定します。通常、API通信では暗号化された `https` が使用されます。
-   **ホスト名 (Hostname)**: APIサーバーのドメイン名を指定します。例: `api.github.com`。
-   **パス (Path)**: ホスト上のリソース（APIのエンドポイント）を指す具体的な経路を示します。例: `/search/repositories`。
-   **クエリパラメータ (Query Parameters)**: パスに続く `?` 以降の部分で、`キー=値` のペアを `&` で連結して指定します。APIに対して追加の情報（検索条件、ソート順、ページネーションなど）を提供します。

## 2. GitHubリポジトリ検索APIのURL構成 (本コードにおける実践)

提供されたコードでは、特に `SearchRepositoriesRequest.swift` がGitHubのリポジトリ検索APIへのリクエストを定義しています。この構造体と、それをサポートする `APIRequestProtocol.swift` から、URLの構成要素がどのように組み立てられるかを確認できます。

### a. スキームとホスト名 (ベースURL)

-   **定義**: `SearchRepositoriesRequest.swift` 内で `baseURL` プロパティとして定義されています。
    ```swift
    var baseURL: URL {
        guard let baseURL = URL(string: "https://api.github.com") else { fatalError("error baseURL") }
        return baseURL
    }
    ```
-   **スキーム**: `https`
-   **ホスト名**: `api.github.com`
-   これらを合わせた `https://api.github.com` が、すべてのGitHub APIリクエストの基礎となるURLです。

### b. パス (エンドポイント)

-   **定義**: `SearchRepositoriesRequest.swift` 内で `path` プロパティとして定義しています。
    ```swift
    var path: String = "/search/repositories"
    ```
-   **役割**: GitHub APIの中で、「リポジトリを検索する」という特定のアクションを実行するエンドポイントを指します。GitHub APIのドキュメント (Source 1.1, 1.4) によると、`GET /search/repositories` がリポジトリ検索のための正式なエンドポイントです。

### c. HTTPメソッド

-   **定義**: `SearchRepositoriesRequest.swift` 内で `method` プロパティとして定義しています。
    ```swift
    var method: HTTPMethod = .get // HTTPMethod.swift で .get は "GET" と定義
    ```
-   **役割**: GitHubリポジトリ検索APIは、`GET` メソッドを使用してリクエストを受け付けます (Source 1.1, 2.4)。

### d. クエリパラメータ

-   **定義**: `SearchRepositoriesRequest.swift` 内で `urlQueryItem` プロパティとして定義されています。
    ```swift
    var urlQueryItem: URLQueryItem? {
        URLQueryItem(name: "q", value: searchWord)
    }
    ```
-   **`q` パラメータ**:
    -   **役割**: GitHub APIにおいて、検索クエリ（キーワードや修飾子）を指定するための主要なパラメータです (Source 1.1, 2.1)。`searchWord` プロパティの値がこの `q` パラメータの値として設定されます。
    -   **例**: ユーザーが "swift" と検索した場合、クエリパラメータは `q=swift` となります。

-   **その他の一般的なクエリパラメータ (GitHub APIリファレンスより)**:
    提供コードでは現在 `q` パラメータのみが使用されていますが、GitHubのリポジトリ検索APIは他にも多くのクエリパラメータをサポートしています (Source 2.1)。これらを利用することで、より詳細な検索が可能です。
    -   `sort`: ソートするフィールドを指定します（例: `stars`, `forks`, `updated`）。デフォルトはベストマッチ。
    -   `order`: ソート順を指定します（`asc` または `desc`）。`sort` パラメータが指定されている場合のデフォルトは `desc`。
    -   `per_page`: 1ページあたりの結果数を指定します（最大100）。
    -   `page`: 取得する結果のページ番号を指定します。

    これらの追加パラメータは、将来的に検索機能を拡張する際に、`APIRequestProtocol` や各リクエスト構造体に組み込むことができます。

## 3. URLの構築プロセス (コード内での実践)

`APIRequestProtocol.swift` に定義された `buildURLRequest()` メソッドが、これらの構成要素を組み合わせて最終的な `URLRequest` オブジェクトを生成します。

```swift
// APIRequestProtocol.swift の buildURLRequest() より抜粋
extension APIRequestProtocol {
    func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path) // ベースURLとパスを結合
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue // HTTPメソッド設定

        switch method {
        case .get:
            if let urlQueryItem = urlQueryItem {
                components?.queryItems = [urlQueryItem] // クエリパラメータを追加 (現在は単一のみ対応)
            }
            urlRequest.url = components?.url // 最終的なURLを生成
            return urlRequest
        // ... (他のHTTPメソッドの処理)
        }
    }
}