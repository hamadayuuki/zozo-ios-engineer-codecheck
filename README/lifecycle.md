# UIViewControllerのライフサイクルについて

iOSアプリケーションにおける画面表示の基礎となる `UIViewController` のライフサイクルと、その各段階で実行される処理について理解を深めることができました。特に `viewDidLoad()` メソッドが、画面初期化において中心的な役割を担っている点が明確になりました。

## 参考記事

[UIViewControllerのライフサイクル](https://qiita.com/motokiee/items/0ca628b4cc74c8c5599d)


<img width = 500 src = "https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F45525%2F670d0038-6f03-095f-ca22-90c510f8babf.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=092e174490ef0bc8a01e289bcff247fb">

## `viewDidLoad()` の役割とタイミング

`SearchRepositoryViewController` および `RepositoryDetailViewController` の両方において、`viewDidLoad()` メソッド内で画面表示に必要な初期設定の大部分が実行されています。

`SearchRepositoryViewController` の例では、以下の処理が行われています。

* Viewの背景色の設定 (`view.backgroundColor = .white`)
* UIコンポーネント（`searchBar`, `collectionView`）のインスタンス化とレイアウト設定 (`configureViews()`)
* `UICollectionViewDiffableDataSource` の初期化と設定 (`configureDataSource()`)
* ViewModel (`viewModel`) とのデータバインディング設定 (`setupBinding()`)

これらの処理は、画面の基本的な外観と動作を定義するために不可欠です。

同様に、`RepositoryDetailViewController` でも、`viewDidLoad()` 内で以下の初期設定が行われています。

* Viewの背景色の設定
* UIコンポーネント（`thumbnailImageView`, `repositoryNameLabel` など）のインスタンス化とStackViewを用いたレイアウト構成 (`configureViews()`)
* ViewModelとのデータバインディング設定 (`setupBinding()`)
* ViewModelに対する初期データ読み込みの指示 (`Task { await viewModel.viewDidLoad() }`)

`viewDidLoad()` は、対象のViewコントローラが管理するView階層がメモリにロードされた直後に、システムによって一度だけ呼び出されるメソッドです。この特性から、Viewの初回ロード時に一度だけ実行すればよい初期化処理（UI部品の生成、制約設定、データソースの準備、一度きりのイベント購読設定など）を行うのに最適なタイミングであると言えます。これらの初期設定を `viewDidLoad()` に集約することは、iOS開発における基本的なプラクティスであることを理解しました。

## その他の主要なライフサイクルメソッド

`viewDidLoad()` 以外にも、`UIViewController` には画面の状態遷移の各段階で呼び出される重要なライフサイクルメソッドが存在します。本課題のコードでは明示的に使用されていませんでしたが、その役割を理解しておくことは重要です。

* **`viewWillAppear(_ animated: Bool)`**: Viewが画面に表示される直前に呼び出されます。このメソッドはViewが表示されるたびに呼び出されるため、画面表示の都度更新が必要な処理（例: 他の画面での変更を反映するためのデータ再取得）に適しています。
* **`viewDidAppear(_ animated: Bool)`**: Viewが画面に完全に表示された直後に呼び出されます。アニメーションの開始や、表示後にリソースを消費する処理の開始などに利用されます。
* **`viewWillDisappear(_ animated: Bool)`**: Viewが画面から非表示になる直前に呼び出されます。進行中の処理の停止、入力内容の保存、UIの状態のクリーンアップなどに使用されます。
* **`viewDidDisappear(_ animated: Bool)`**: Viewが画面から完全に非表示になった直後に呼び出されます。リソースの解放など、画面が表示されていない間は不要な処理の実行に適しています。

## ライフサイクルを考慮した実装の重要性

`UIViewController` のライフサイクルメソッドが呼び出されるタイミングと各メソッドの責務を正確に理解し、それぞれの段階で適切な処理を記述することが、予期せぬ動作を防ぎ、効率的で安定したアプリケーションを構築する上で不可欠です。特に、`viewDidLoad()` で初期設定を完了させ、必要に応じて他のライフサイクルメソッドで状態に応じた処理を行うという流れは、iOSアプリケーション開発の基本であると認識しました。ViewModelとの連携においても、ライフサイクルのどの段階でデータフローを開始・更新・停止するかを考慮することが重要となります。