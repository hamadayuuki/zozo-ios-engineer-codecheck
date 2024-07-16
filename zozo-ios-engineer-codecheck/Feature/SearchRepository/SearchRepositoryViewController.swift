//
//  SearchRepositoryViewController.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/25.
//

import UIKit
import Combine
import SnapKit

class SearchRepositoryViewController: UIViewController {
    /// SearchRepositoryViewController の DiffableDataSource 用に定義
    private enum SectionType {
        case repositories
    }

    private var dataSource: UICollectionViewDiffableDataSource<SectionType, GithubRepository>!
    private let viewModel: SearchRepositoryViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SearchRepositoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configDataSource()
        configureViews()
        setupBinding()
        getButtonTapped()
    }

    // MARK: - UI compornents

    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init())
        collectionView.frame = self.view.frame
        collectionView.register(RepositoryViewCell.self, forCellWithReuseIdentifier: String(describing: RepositoryViewCell.self))
        return collectionView
    }()

    // MARK: - function

    private func configureViews() {
        // CollectionView
        let layout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let spacing: CGFloat = 12
            let width = self.view.bounds.width - (spacing * 2)

            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))   // TODO: - 高さを動的化
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            return section
        }
        collectionView.collectionViewLayout = layout
        self.view.addSubview(collectionView)
    }

    private func configDataSource() {
        // registration
        let repositoryCell = UICollectionView.CellRegistration<RepositoryViewCell, GithubRepository>() { cell, _, repository in
            let cellState: RepositoryViewCell.State = .init(
                repoName: repository.fullName,
                repoDescription: repository.description,
                stargazersCount: repository.stargazersCount,
                language: repository.language
            )
            cell.setState(state: cellState)
        }

        // dataSource
        dataSource = .init(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, repository in
                collectionView.dequeueConfiguredReusableCell(using: repositoryCell, for: indexPath, item: repository)
            }
        )

        // snapshot
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, GithubRepository>()
        snapshot.appendSections([.repositories])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    /// GitHubAPIから正常にレスポンスを受け取れ場合レポジトリ一覧のデータ更新する
    private func updateDataSource(repositories: [GithubRepository]) {
        var snapShot = dataSource.snapshot()
        snapShot.appendItems(repositories, toSection: .repositories)
        dataSource.apply(snapShot, animatingDifferences: true)
    }

    private func setupBinding() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .initial, .loading:
                    // TODO: - ローディング画面
                    break
                case .success(let response):
                    let repositories = response.items
                    updateDataSource(repositories: repositories)
                case .error(let errorDescription):
                    print(errorDescription)
                    // TODO: - エラー画面
                }
            }
            .store(in: &cancellables)
    }

    private func getButtonTapped() {
        Task {
            try await viewModel.tappedGetButton(searchWord: "Swift")
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
