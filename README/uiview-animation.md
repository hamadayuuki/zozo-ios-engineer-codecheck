参考 : [UIViewPropertyAnimatorを使ってアニメーションをコントロールする](https://qiita.com/hachinobu/items/57d4c305c907805b4a53)

**UIView\.animation** と **UIView\.translation** について

---

## UIView\.animate とは

### 概要

- クロージャ内でプロパティ（例: frame, alpha, transformなど）を変更するだけで、その変更がアニメーションされる。
- completion（アニメーション終了後の処理）も設定可能。
- タイミングや繰り返し、遅延などのオプションも指定できる。

代表的な使い方は以下の通りです。
この例では、`view` の透明度が1秒かけて0になります。

```swift
UIView.animate(withDuration: 1.0) {
    view.alpha = 0.0
}
```
はい、このコードは**UIKit**でよく使われる`UIView.animate`メソッドを使ったアニメーション処理の例です。
ひとつずつ分解して説明します。

---


**コードの解説**

```swift
UIView.animate(
    withDuration: 1.0, 
    delay: 0.0, 
    options: [.repeat], 
    animations: { 
        iconFingerImageView.frame.origin.x -= 50.0
    }, 
    completion: nil
)
```

### 挙動

1. アニメーション開始時に、`iconFingerImageView`のx座標が現在値から**50ポイント左**に1秒かけて移動します。
2. アニメーションが終わると、また同じだけ左に移動します（繰り返しなので）。
3. この処理が**無限ループ**で続き、`iconFingerImageView`はどんどん左に流れていきます。

#### 各パラメータの意味

- **withDuration: 1.0**
  アニメーションにかける時間（秒）。この場合は**1秒**で処理が実行されます。

- **delay: 0.0**
  アニメーションを開始するまでの遅延時間（秒）。0なので即時開始です。

- **options: \[.repeat]**
  `.repeat`オプションを指定しているので、アニメーションが**永遠に繰り返されます**。

- **animations: { ... }**
  ここにアニメーションさせたい内容を書きます。
  `iconFingerImageView.frame.origin.x -= 50.0`
  → `iconFingerImageView` というUIImageViewのx座標（横位置）が**左方向に50ポイント移動**します。

- **completion: nil**
  アニメーション終了時に呼ばれるクロージャ。今回は何もしないので`nil`です。



## UIView\.translation とは

### 概要
- translation** はUIViewの「移動」を指す表現です。実際には `transform` プロパティを使って\*\*平行移動（translation）\*\*のアニメーションを実現します。
- 具体的には、CGAffineTransformを使って位置をずらします。
-  transformを用いた移動は、frameそのものを変更しない（見た目だけ移動）。
-  元の位置に戻すには `view.transform = .identity` を使う。

以下の例では、`view` が右方向に100pt平行移動します。

```swift
UIView.animate(withDuration: 1.0) {
    view.transform = CGAffineTransform(translationX: 100, y: 0)
}
```



## まとめ

| 機能                     | 説明                              | 例                              |
| ---------------------- | ------------------------------- | ------------------------------ |
| UIView\.animate        | プロパティ変更をアニメーションで実現するUIKit標準メソッド | alpha変更、transform変更 など         |
| translation            | transformを使ってviewを平行移動させること     | translationX, translationY を利用 |
| UIViewPropertyAnimator | より高度なアニメーション制御ができるクラス           | 一時停止、再開、逆再生 など                 |

---

