//
//  RepositoryViewCell.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/07/04.
//

import UIKit
import SnapKit

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

    // TODO: - Coreフォルダを作りUILabel(やフォントサイズなど)を共通化する
    private let repoName: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    private let repoDescription: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0   // 高さ動的化のため
        return label
    }()

    private let stargazersCount: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    private let language: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        configureViewCell()
    }

    private func configureViewCell() {
        addSubview(repoName)
        repoName.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()   // 文字を折り返して表示するため
        }

        addSubview(repoDescription)
        repoDescription.sizeToFit()
        repoDescription.snp.makeConstraints {
            $0.top.equalTo(repoName.snp.bottom).offset(12)
            $0.width.equalToSuperview()
        }

        addSubview(stargazersCount)
        stargazersCount.snp.makeConstraints {
            $0.top.equalTo(repoDescription.snp.bottom).offset(12)
        }

        addSubview(language)
        language.snp.makeConstraints {
            $0.top.equalTo(stargazersCount.snp.bottom).offset(12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setState(state: State) {
        repoName.text = state.repoName
        repoDescription.text = state.repoDescription
        stargazersCount.text = "\(state.stargazersCount)"
        language.text = state.language
    }
}
