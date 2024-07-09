//
//  RepositoryViewCell.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/07/04.
//

import UIKit

class RepositoryViewCell: UICollectionViewCell {
    /// RepositoryViewCell の状態管理用
    ///
    /// 名前空間を考慮している。
    /// 使う時には `RepositoryViewCell.State` とする
    struct State {
        let repoName: String
        let repoDescription: String
        let stargazersCount: Int
        let language: String
    }

    static let cellHeight: CGFloat = 150

    // TODO: - SnapKit 用いてレイアウト実装する
    // https://github.com/SnapKit/SnapKit
    private let repoName: UILabel = .init(frame: .init(x: 0, y: 0, width: 100, height: 30))
    private let repoDescription: UILabel = .init(frame: .init(x: 0, y: 30, width: 100, height: 30))
    private let stargazersCount: UILabel = .init(frame: .init(x: 0, y: 60, width: 100, height: 30))
    private let language: UILabel = .init(frame: .init(x: 0, y: 90, width: 100, height: 30))

    override init(frame: CGRect) {
        super.init(frame: .zero)

        configureViewCell()
    }

    private func configureViewCell() {
        self.addSubview(repoName)
        self.repoName.text = "hogehoge"
        // repoName のレイアウト実装

        self.addSubview(repoDescription)
        self.repoDescription.text = "hugahuga"

        self.addSubview(stargazersCount)
        self.stargazersCount.text = "\(10)"

        self.addSubview(language)
        self.language.text = "swift"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setState(state: State) {
        self.repoName.text = state.repoName
        self.repoDescription.text = state.repoDescription
        self.stargazersCount.text = "\(state.stargazersCount)"
        self.language.text = state.language
    }
}
