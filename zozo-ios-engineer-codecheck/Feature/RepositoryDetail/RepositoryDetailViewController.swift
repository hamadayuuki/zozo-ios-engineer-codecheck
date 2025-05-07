//
//  RepositoryDetailViewController.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/07.
//

import UIKit
import SnapKit
import Kingfisher

// モック用に作成
// 今後APIからのレスポンスを定義し、以下のRepositoryは削除
struct Repository {
    let thumbnail_url: String
    let name: String
    let owner: String
    let description: String
    let stars: Int
    let forks: Int
    let language: String
}

class RepositoryDetailViewController: UIViewController {
    var repository: Repository? {
        didSet {
            updateUI()
        }
    }

    // MARK: - UI components

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let repositoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()

    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    private let starCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let forkCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        view.backgroundColor = .white

        // ダミーデータ
        repository = Repository(
            thumbnail_url: "https://cdn.pixabay.com/photo/2022/01/30/13/33/github-6980894_1280.png",
            name: "SwiftUI-MVVM-Example",
            owner: "apple",
            description: "A comprehensive example of using SwiftUI with the MVVM architecture.",
            stars: 1234,
            forks: 567,
            language: "Swift"
        )
    }

    // MARK: - function

    private func configureViews() {
        let infoHorizontalStack = UIStackView(arrangedSubviews: [starCountLabel, forkCountLabel])
        infoHorizontalStack.axis = .horizontal
        infoHorizontalStack.spacing = 16
        infoHorizontalStack.alignment = .leading

        let mainVerticalStack = UIStackView(arrangedSubviews: [thumbnailImageView, repositoryNameLabel, ownerNameLabel, languageLabel, descriptionLabel, infoHorizontalStack])
        mainVerticalStack.axis = .vertical
        mainVerticalStack.spacing = 16
        mainVerticalStack.alignment = .leading
        view.addSubview(mainVerticalStack)

        mainVerticalStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        thumbnailImageView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
    }

    private func updateUI() {
        guard let repo = repository else { return }
        guard let thumbnailURL = URL(string: repo.thumbnail_url) else { return }

        thumbnailImageView.kf.setImage(with: thumbnailURL)
        navigationItem.title = repo.name
        repositoryNameLabel.text = repo.name
        ownerNameLabel.text = "by \(repo.owner)"
        descriptionLabel.text = repo.description
        starCountLabel.text = "⭐︎ " + "\(repo.stars)"
        forkCountLabel.text = "🍴 " + "\(repo.forks)"
        languageLabel.text = repo.language
    }
}
