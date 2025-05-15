# ViewModelにおける疎結合・抽象化・凝集度の工夫

ViewModel (`SearchRepositoryViewModel.swift` および `RepositoryDetailViewModel.swift`) では、MVVMアーキテクチャの原則に基づき、protocolを用いて、疎結合、抽象化（特にプロトコルによる抽象化）、凝集を実現しています。

## 1. 疎結合 (Loose Coupling)

ViewModelレイヤーにおける疎結合は、主に以下の点で実現されています。

### a. ViewModelとView (ViewController) の分離

-   **インターフェースとしてのプロトコル**:
    各ViewModel (`SearchRepositoryViewModel`, `RepositoryDetailViewModel`) は、`Input` と `Output` を定義したプロトコル（例: `SearchRepositoryViewModelInput`, `SearchRepositoryViewModelOutput`, `SearchRepositoryViewModelProtocol`）を公開しています。
-   **効果**:
    ViewControllerは、ViewModelの具体的な実装クラスではなく、これらの**プロトコル（抽象インターフェース）**に依存します。これにより、ViewModelの内部実装が変更されても、プロトコルのインターフェース（契約）が維持されていればViewControllerへの影響を最小限に抑えることができます。テスト時には、このプロトコルに準拠したモックViewModelを容易に差し替えることが可能になり、テスト容易性が向上します。

### b. ViewModelとModel (データ層/APIClient) の分離

-   **`APIClientProtocol` への依存**:
    両ViewModelは、具体的な `APIClient` の実装に直接依存するのではなく、`APIClientProtocol` という**抽象インターフェース（プロトコル）**に依存しています。
    ```swift
    // SearchRepositoryViewModel.swift の例
    // apiClient は APIClientProtocol というプロトコル型で宣言
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    ```
-   **効果**:
    これにより、ViewModelはネットワーク通信の具体的な実装詳細から切り離されます。例えば、`APIClient` の実装が `URLSession` から別のライブラリに変更されたとしても、`APIClientProtocol` のインターフェースが保たれていればViewModel側のコード修正は不要です。これもテスト時にモックAPIクライアントを注入することを容易にし、疎結合を実現します。

## 2. 抽象化 (Abstraction) とプロトコルの役割

抽象化は、複雑な詳細を隠蔽し、本質的な機能やインターフェースのみを利用側に見せることです。プロトコルはSwiftにおいてこの抽象化を実現する強力な手段です。

### a. ViewModelの振る舞いの抽象化 (プロトコルによるインターフェース定義)

-   **`Input`/`Output` プロトコルの定義**:
    - kickstarter のViewModelを[参考](https://qiita.com/muukii/items/045b12405f7acff1a9fd)にしています
    -   `SearchRepositoryViewModelInput` は「ViewModelに対してどのような操作が可能か（例: `searchButtonTapped(searchWord: String)`）」という**振る舞いの契約を抽象的に定義**します。
    -   `SearchRepositoryViewModelOutput` は「ViewModelからどのような情報が提供されるか（例: `var state: State { get }`）」という**公開される状態の契約を抽象的に定義**します。
    -   同様に `RepositoryDetailViewModelInput` および `RepositoryDetailViewModelOutput` も、詳細画面ViewModelの振る舞いと公開情報を抽象化しています。
-   **効果**:
    これらのプロトコルは、ViewModelが持つべき「責任」や「能力」を明確に示します。ViewControllerは、ViewModelの具体的な実装詳細（「どのように」ロジックが実行されるか）を知ることなく、この**プロトコル（抽象化されたインターフェース）**を通じてViewModelと連携します。これにより、ViewModelの内部実装とViewの関心が明確に分離されます。

### b. 外部依存性の抽象化 (プロトコルによるAPIクライアントの抽象化)

-   **`APIClientProtocol` の利用**:
    前述の通り、ViewModelは `APIClientProtocol` に依存します。これは、データ取得という「機能」を抽象化したインターフェースです。
-   **効果**:
    ViewModelは「どのようにデータを取得するか」という具体的なネットワーク通信の実装を知らなくてもすみます。（ブラックボックス化できる）
    `APIClientProtocol` が定義する `request()` メソッドの存在だけを知っていればよく、複雑な処理（URL構築、セッション管理、エラーハンドリングなど）は隠蔽されています。これも**プロトコルを用いた強力な抽象化**の一例です。

### c. 状態表現の抽象化 (`enum State` の活用)

-   **`SearchRepositoryViewModel.State`**:
    `SearchRepositoryViewModel` で定義されている `enum State` は、画面が取りうる複数の状態（初期状態、読み込み中、成功、エラー）を一つの型として抽象化しています。
-   **効果**:
    個々の状態フラグ（例: `isLoading`, `isError`, `dataLoaded` など）を個別に管理する代わりに、`State` という単一の型で画面の状態を表現することで、状態遷移の管理が容易になり、不正な状態の組み合わせを防ぐことができます。これは、複雑なUIの状態をよりシンプルで扱いやすい形に**抽象化する**テクニックです。

## 3. 凝集度 (Cohesion)

凝集度は、モジュール内の要素が単一の明確な目的のためにどれだけ密接に関連しているかを示します。ViewModelは、特定のビューに関連するロジックと状態管理に責任を集中させることで、高い凝集度を目指します。

### a. 単一責任の原則への配慮

-   **各ViewModelの明確な責務**:
    -   `SearchRepositoryViewModel` は、「リポジトリ検索画面」の表示ロジック、ユーザー入力処理、データ取得の指示、状態管理といった、この画面に特化した責務を担います。
    -   `RepositoryDetailViewModel` は、「リポジトリ詳細画面」のデータ取得と表示に必要な状態の管理に責務を集中させています。
-   **効果**:
    各ViewModelが特定のUI（ビュー）とそのロジックに密接に関連する要素だけを持つことで、関心事が明確に分離され、コードの理解や変更が容易になります。これにより、ViewModelの内部の一貫性が高まり、凝集度が高い状態が保たれます。

