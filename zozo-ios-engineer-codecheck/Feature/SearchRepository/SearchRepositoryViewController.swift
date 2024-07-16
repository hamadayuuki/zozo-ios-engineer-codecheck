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
    private var repository: SearchRepositoriesResponse = .init(items: [])   // TODO: 削除, VMで状態管理する
    private let viewModel: SearchRepositoryViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SearchRepositoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureViews()
        setupBinding()
        getButtonTapped()
    }

    // MARK: - UI compornents

    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init())
        collectionView.frame = self.view.frame
        collectionView.delegate = self
        collectionView.dataSource = self
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

    private func setupBinding() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .initial, .loading:
                    // TODO: - ローディング画面
                    break
                case .success(let repositories):
                    self.repository = repositories
                    self.collectionView.reloadData()
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

// MARK: - UICollectionViewDataSource

extension SearchRepositoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        repository.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RepositoryViewCell.self), for: indexPath) as? RepositoryViewCell else { fatalError("Unable to dequeue CustomCollectionViewCell") }
        // TODO: - DiffableDataSourceへ置き換え
        let item = repository.items[indexPath.item]
        let cellState: RepositoryViewCell.State = .init(
            repoName: item.fullName,
            repoDescription: item.description,
            stargazersCount: item.stargazersCount,
            language: item.language
        )
        cell.setState(state: cellState)
        return cell
    }
}
