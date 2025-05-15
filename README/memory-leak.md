# Swiftにおけるメモリ管理と循環参照への対策

Swiftでは、Automatic Reference Counting (ARC) によりメモリ管理が自動化されています。しかし、開発者が参照の仕組みを正しく理解し、適切に扱うことで、メモリリークを未然に防ぎ、安定したアプリケーションを構築することが可能です。ARCやstrong・weak・unowned参照、メモリリークの原因となる循環参照、およびその回避策について解説します。また、コードをもとにメモリリーク防止対策について説明します。


## 1. Automatic Reference Counting (ARC) の基本

ARCは、メモリを追跡し管理する仕組みです。
クラスが新しいインスタンスを生成するたびに、ARCがインスタンス情報を格納するためにメモリの一部を確保し、管理します。
また、インスタンスが不要になった場合は、ARCがインスタンスが使用していたメモリを解放します。
このように、ARCは参照カウントを増減させながら、自動的にメモリを管理しています。


-   **参照カウント**: インスタンスへの強い参照が新たに作られるとカウントが増え、強い参照がなくなるとカウントが減ります。
-   **メモリ解放**: 参照カウントが0になると、そのインスタンスはもはや不要と判断され、ARCによってメモリから解放（デアロケート）されます。

この仕組みにより、開発者は手動でメモリを解放する手間から解放されますが、参照の仕方を誤ると意図しないメモリ保持が発生する可能性があります。意図しないメモリ保持は、アプリクラッシュに繋がります。
メモリ保持が発生する原因は、クラスを参照する種類にあります。
メモリ保持の原因および参照の種類について下記で説明します。

## 2. 循環参照とメモリリーク

**メモリリーク**とは、プログラムが確保したメモリが、不要になった後も解放されずに残り続けてしまう現象です。これが蓄積すると、メモリ量が多くなり、アプリケーションのパフォーマンス低下やクラッシュを引き起こす可能性があります。

**循環参照 (Retain Cycle)** は、メモリリークの主要な原因の一つです。これは、2つ以上のクラスインスタンスが互いに強い参照を持ち合い、結果としてどのインスタンスの参照カウントも0にならず、ARCによるメモリ解放が行われなくなる状態を指します。この問題をメモリリークの一般的な原因として指摘しています。
オブジェクトAがオブジェクトBへの強い参照を持ち、オブジェクトBもオブジェクトAへの強い参照を持つ場合、お互いを「生かし続ける」ために参照カウントが0にならず、メモリ上に残り続けてしまいます。

## 3. 参照の種類

Swiftには主に以下の3つの参照型があります。

### `strong` 参照 (強参照)

-   デフォルトの参照型です。
-   インスタンスへの強い参照は、そのインスタンスの参照カウントを増加させます。
-   参照カウントが1以上である限り、インスタンスはメモリ上に保持されます。
-   2つのオブジェクトが互いに `strong` 参照を持ち合うと、循環参照の原因となります（例: `var catTableView: catList!` と `cell.catTableView = self` のような相互参照）。

### `weak` 参照 (弱参照)

-   インスタンスへの参照を保持しますが、参照カウントは増加させません。
-   そのため、`weak` 参照はインスタンスの生存期間に影響を与えません。
-   参照先のインスタンスが解放されると、`weak` 参照は自動的に `nil` に設定されます。このため、`weak` 参照は必ずオプショナル型 (`Optional<Type>`) であり、かつ再代入可能な変数 (`var`) として宣言する必要があります。これらのことから、 [weak self] で定義した self はOptional型 です。
-   **使用タイミング**:
    -   **循環参照の回避**: 強調されているように、2つのインスタンスが互いに強く参照し合う可能性がある場合に、一方の参照を `weak` にすることで `循環参照を断ち切ります`。
        -   **Delegateパターン**: デリゲートプロパティを `weak var delegate: catListActionDelegate?` のように宣言することで、デリゲート元とデリゲート間の循環参照を防ぐ例が示されています。
        -   **クロージャ**: 後述しますが、クロージャが `self` を強くキャプチャする場合にも循環参照を避けるために使用されます。



## 4. 循環参照の回避策

循環参照を回避するための主な方法は、参照のループを断ち切ることです。

### `weak` 参照 を採用する

-   循環参照を引き起こす可能性のある2つのインスタンス間の参照のうち、一方を `weak`に変更します。
    -   **`weak`**: 参照先が先に解放される可能性がある場合（例: Delegateパターン）

クロージャも参照型であり、クラスインスタンスのプロパティとして保持されたり、非同期処理で利用されたりする際に、インスタンス (`self`) をキャプチャすることで循環参照を引き起こすことがあります。

-   **キャプチャリスト `[weak self]`**: 記事（※1）で解決策として触れられているように、クロージャが `self` をキャプチャする際に `[weak self]` を使用すると、クロージャは `self` を弱い参照として保持します。クロージャ内で `self` はオプショナル (`self?`) となり、アクセス前に `nil` チェック（例: `guard let self else { return }`）を行うことが一般的です。

## 5. 提供コードにおける実践例

提供されたコードベースでは、特にクロージャにおける循環参照の回避策として `[weak self]` が効果的に使用されています。

1.  **`SearchRepositoryViewController.swift`**

    ```swift
    // setupBinding() メソッド内
    viewModel.$state
        .receive(on: DispatchQueue.main)
        .sink { [weak self] state in // 循環参照を避けるため [weak self] を使用
            guard let self else { return }
            // ... UI更新処理 ...
        }
        .store(in: &cancellables)
    ```
    このコードでは、`sink` クロージャが `self` (ViewControllerのインスタンス) をキャプチャしています。ViewControllerは `cancellables` を通じてこの購読を保持するため、`[weak self]` を使用しないと循環参照が発生します。`[weak self]` により、ViewControllerへの強い参照がクロージャ内に作られるのを防いでいます。

2.  **`RepositoryDetailViewController.swift`**

    ```swift
    // setupBinding() メソッド内
    viewModel.$repositoryDetail
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in // 同様に [weak self] を使用
            self?.updateUI()
        }
        .store(in: &cancellables)
    ```

3.  **`APIClientViewController.swift`**

    ```swift
    // setupBinding() メソッド内
    viewModel.$isLoading
        .receive(on: DispatchQueue.main)
        .sink { [weak self] isLoading in // 同様に [weak self] を使用
            self?.view.backgroundColor = isLoading ? .gray : .white
        }
        .store(in: &cancellables)

    // getButton の UIAction 初期化クロージャ内
    button.addAction(
        .init { [weak self] _ in // 同様に [weak self] を使用
            self?.getButtonTapped()
        },
        for: .touchUpInside
    )
    ```
    これらの箇所でも同様に、クロージャが `self` をキャプチャする際に `[weak self]` を使用することで、潜在的な循環参照とそれに伴うメモリリークを効果的に回避しています。

## 6. メモリリークの検出

-   **Xcodeのデバッグツール**: メモリグラフデバッガ (Memory Graph Debugger) を使用すると、オブジェクト間の参照関係を視覚的に確認でき、循環参照を発見するのに役立ちます。
-   **[XCTAssertNoLeak](https://github.com/tarunon/XCTAssertNoLeak)**: 対象のインスタンス内にメモリりーくが発生しているか検知する機能を持つライブラリを使い、メモリリークを検知する。


## 7. 実際にメモリリーくの検出してみる

[参考](https://qiita.com/toya108/items/872568c1c9837caf3dfe#%E3%83%A1%E3%83%A2%E3%83%AA%E3%83%AA%E3%83%BC%E3%82%AF%E3%81%AE%E6%A4%9C%E7%9F%A5%E6%96%B9%E6%B3%95)

**Memory graphを利用する**
アプリが確保しているメモリとインスタンスを可視化してくれる


**Debug NavigatorからMemoryを確認する**
メモリ量を確認できる

