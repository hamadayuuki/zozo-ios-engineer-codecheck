# zozo-ios-engineer-codecheck


## 実行環境設定

### Xcode

前提として、`Xcode@15.2` と `homebrew` はインストールされているものとします。


### Formater & Linter

クリーンなコードを書くためコード記法を統一させたいです。
そのため、SwiftLintを用いてビルド毎に Formatter,Linter を実行させます。


#### 1. SwiftLint をローカルへインストール


```.bash
$ brew install swiftlint
```

インストール後はビルドして Formatter,Linter が動作するか確認してください。
動作しない場合は、以下に示す2,3が完了しているか確認してください。


#### 2. User Script Sandboxing をNoへ変更

TARGETS(プロジェクト) > Build Settings > All+Combined > User Script Sandboxing > No


#### 3. Build Phases にスクリプト記述

TARGETS(プロジェクト) > Build Phases > +

「Formatter and Linter」など適当な名称をつけ、以下のスクリプトを記述する。

```.sh
# TODO
#   - $ brew install swiftlint

# for Apple Silicon Mac (M1〜)
# https://zenn.dev/muhiro12/articles/swiftlint-m1-issue
export PATH=/opt/homebrew/bin/:$PATH

if which swiftlint >/dev/null; then
    swiftlint --fix   # formatter
    swiftlint         # linter
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi

```

Runscript のチェックボックスは全て**外す**
