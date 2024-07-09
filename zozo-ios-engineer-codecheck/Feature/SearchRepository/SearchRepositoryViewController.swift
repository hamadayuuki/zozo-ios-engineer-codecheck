//
//  SearchRepositoryViewController.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/25.
//

import UIKit
import Combine

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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RepositoryViewCell.self, forCellWithReuseIdentifier: String(describing: RepositoryViewCell.self))
        return collectionView
    }()

    // MARK: - function

    private func configureViews() {
        /// Items layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(
            width: self.view.frame.width - 30,
            height: RepositoryViewCell.cellHeight
        )

        collectionView.collectionViewLayout = flowLayout
        collectionView.frame = self.view.frame
        self.view.addSubview(collectionView)
    }

    private func setupBinding() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)   // メインスレッドで実行
            .sink { [weak self] isLoading in   // 循環参照を防ぐ
                self?.view.backgroundColor = isLoading ? .gray : .white
            }
            .store(in: &cancellables)

        viewModel.$repositories
            .dropFirst()   // 初期値設定分の通知を無視
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repos in
                guard let self else { return }
                self.repository = repos
                self.collectionView.reloadData()
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
        cell.backgroundColor = .gray
        return cell
    }
}
