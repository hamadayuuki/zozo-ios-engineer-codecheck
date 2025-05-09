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
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let repoDescription: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0   // 高さ動的化のため
        return label
    }()

    private let stargazersCount: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.setContentHuggingPriority(.required, for: .horizontal)   // 領域拡大によるレイアウト崩れ防止
        return label
    }()

    private let language: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.setContentCompressionResistancePriority(.required, for: .horizontal)   // 領域縮小によるレイアウト崩れ防止
        return label
    }()

    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .systemGray5
        return divider
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        configureViewCell()
    }

    private func configureViewCell() {
        let space: CGFloat = 12
        let horizontalStackView = UIStackView(arrangedSubviews: [stargazersCount, language])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = space

        let stackView = UIStackView(arrangedSubviews: [repoName, repoDescription, horizontalStackView])
        stackView.axis = .vertical
        stackView.spacing = space
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(space).priority(.low)   // collectionViewの動的なアイテムサイズ(.estimated(1))が原因で Auto Layout の競合が発生したため、垂直方向の制約の優先度を下げて (priority(.low)) 、競合を解決
        }

        contentView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(space)   // stackViewの上下に余白を12とっているためoffsetで表示位置ずらしても問題ない
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setState(state: State) {
        repoName.text = state.repoName
        repoDescription.text = state.repoDescription
        stargazersCount.text = "⭐︎ \(state.stargazersCount)"
        language.text = "✏︎ \(state.language)"
    }
}
