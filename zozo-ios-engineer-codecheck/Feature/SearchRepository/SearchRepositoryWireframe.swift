//
//  SearchRepositoryWireframe.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/21.
//

import UIKit

@MainActor
final class SearchRepositoryWireframe: WireframeProtocol {
    let owner: String
    let repo: String
    init(owner: String, repo: String) {
        self.owner = owner
        self.repo = repo
    }

    func nextVC() -> UIViewController {
        let apiClient: APIClient = .init()
        let repositoryDetailViewModel: RepositoryDetailViewModel = .init(owner: owner, repo: repo, apiClient: apiClient)
        let repositoryDetailViewController = RepositoryDetailViewController(viewModel: repositoryDetailViewModel)
        return repositoryDetailViewController
    }

    func translation(navigationController: UINavigationController?, nextVC: UIViewController) {
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
