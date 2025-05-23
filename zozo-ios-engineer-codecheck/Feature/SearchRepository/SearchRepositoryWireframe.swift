//
//  SearchRepositoryWireframe.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/21.
//

import UIKit

@MainActor
final class SearchRepositoryWireframe: WireframeProtocol {
    typealias Input = (owner: String, repo: String)

    func nextVC(_ input: Input) -> UIViewController {
        let apiClient: APIClient = .init()
        let repositoryDetailViewModel: RepositoryDetailViewModel = .init(owner: input.owner, repo: input.repo, apiClient: apiClient)
        let repositoryDetailViewController = RepositoryDetailViewController(viewModel: repositoryDetailViewModel)
        return repositoryDetailViewController
    }

    func translation(navigationController: UINavigationController?, nextVC: UIViewController) {
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
