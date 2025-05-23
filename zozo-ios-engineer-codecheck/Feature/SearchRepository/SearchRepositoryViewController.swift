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

    private lazy var dataSource: UICollectionViewDiffableDataSource<SectionType, GithubRepository> =  {
        let repositoryCell = UICollectionView.CellRegistration<RepositoryViewCell, GithubRepository>() { cell, _, repository in
            let cellState: RepositoryViewCell.State = .init(
                repoName: repository.fullName,
                repoDescription: repository.description ?? "",
                stargazersCount: repository.stargazersCount,
                language: repository.language ?? ""
            )
            cell.setState(state: cellState)
            cell.tappedStarButton = { [weak self] tappedCell in
                guard let self else { return }

                if let tappedCellIndex = self.collectionView.indexPath(for: tappedCell) {
                    self.viewModel.tappedStarButton(tappedCellIndex: tappedCellIndex.row)
                }
            }
        }

        return .init(
            collectionView: self.collectionView,
            cellProvider: { collectionView, indexPath, repository in
                collectionView.dequeueConfiguredReusableCell(using: repositoryCell, for: indexPath, item: repository)
            }
        )
    }()
    private let viewModel: SearchRepositoryViewModel = .init(apiClient: APIClient())
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self   // UICollectionViewDelegate

        view.backgroundColor = .white
        configureDataSource()
        configureViews()
        setupBinding()
    }

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init())
        collectionView.frame = view.frame
        collectionView.register(RepositoryViewCell.self, forCellWithReuseIdentifier: String(describing: RepositoryViewCell.self))
        return collectionView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = .init()
        searchBar.backgroundImage = .init()   // 枠線削除
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        return searchBar
    }()

    private func configureViews() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        let layout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let space: CGFloat = 12
            let width = self.view.bounds.width - (space * 2)

            /// アイテムサイズ動的化のため
            let heightDimension: NSCollectionLayoutDimension = .estimated(1)
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: heightDimension)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: space, leading: space, bottom: space, trailing: space)
            return section
        }
        collectionView.collectionViewLayout = layout
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }

    // MARK: - function

    private func setupBinding() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .initial:
                    resetDataSource()
                case .loading:
                    break
                    // TODO: - ローディング画面
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

}

// MARK: - UICollectionView

extension SearchRepositoryViewController {

    private func configureDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, GithubRepository>()
        snapshot.appendSections([.repositories])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func resetDataSource() {
        var snapShot = dataSource.snapshot()
        snapShot.deleteAllItems()
        snapShot.appendSections([.repositories])
        dataSource.apply(snapShot, animatingDifferences: true)
    }

    /// GitHubAPIから正常にレスポンスを受け取れ場合レポジトリ一覧のデータ更新する
    private func updateDataSource(repositories: [GithubRepository]) {
        var snapShot = dataSource.snapshot()
        snapShot.appendItems(repositories, toSection: .repositories)
        dataSource.apply(snapShot, animatingDifferences: true)
    }

}

extension SearchRepositoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let repository = dataSource.itemIdentifier(for: indexPath) else { return }
        let wireframe: SearchRepositoryWireframe = .init()
        let nextVC = wireframe.nextVC(SearchRepositoryWireframe.Input(owner: repository.owner.login, repo: repository.name))
        wireframe.translation(navigationController: navigationController, nextVC: nextVC)
    }
}

// MARK: - UISearchBar

extension SearchRepositoryViewController: UISearchBarDelegate {
    // 検索バー編集開始時にキャンセルボタン有効化
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    // キャンセルボタンでキャセルボタン非表示
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }

    // エンターキーで検索
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else { return }
        Task {
            try await viewModel.searchButtonTapped(searchWord: searchWord)
        }

        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
