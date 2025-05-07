//
//  RepositoryDetailViewController.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/07.
//

import UIKit
import SnapKit
import Kingfisher
import Combine

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
    let viewModel: RepositoryDetailViewModel = .init(owner: "hamadayuuki", repo: "irodori", apiClient: APIClient())
    private var cancellables = Set<AnyCancellable>()

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
        setupBinding()
        configureViews()
        Task {
            await viewModel.viewDidLoad()
        }
    }

    // MARK: - function

    private func configureViews() {
        view.backgroundColor = .white

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

    private func setupBinding() {
        viewModel.$repositoryDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }

    private func updateUI() {
        guard let repositoryDetail = viewModel.repositoryDetail else { return }
        if let avatarURL = repositoryDetail.owner.avatarUrl {
            let thumbnailURL = URL(string: avatarURL)
            thumbnailImageView.kf.setImage(with: thumbnailURL)
        }

        navigationItem.title = repositoryDetail.name
        repositoryNameLabel.text = repositoryDetail.name
        ownerNameLabel.text = "by \(repositoryDetail.owner.login)"
        descriptionLabel.text = repositoryDetail.description
        starCountLabel.text = "⭐︎ " + "\(repositoryDetail.stargazersCount)"
        forkCountLabel.text = "🍴 " + "\(repositoryDetail.forksCount)"
        languageLabel.text = repositoryDetail.language
    }
}
