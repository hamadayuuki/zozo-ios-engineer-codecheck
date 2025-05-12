//
//  RepositoryDetailViewModel.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/07.
//

import Foundation

// MARK: - protocol

@MainActor
protocol RepositoryDetailViewModelIntput {
    func viewDidLoad() async throws
}

@MainActor
protocol RepositoryDetailViewModelOutput {
    var repositoryDetail: RepositoryDetailResponse? { get }
}

@MainActor
protocol RepositoryDetailViewModelProtocol: RepositoryDetailViewModelIntput, RepositoryDetailViewModelOutput {}

@MainActor
final class RepositoryDetailViewModel: RepositoryDetailViewModelProtocol {
    @Published private(set) var repositoryDetail: RepositoryDetailResponse?

    let owner: String
    let repo: String
    private let apiClient: APIClientProtocol
    init(owner: String, repo: String, apiClient: APIClientProtocol) {
        self.owner = owner
        self.repo = repo
        self.apiClient = apiClient
    }

    func viewDidLoad() async {
        let request: RepositoryDetailRequest = .init(owner: owner, repo: repo)

        do {
            let response: Result<RepositoryDetailResponse, HTTPError> = try await apiClient.request(apiRequest: request)
            switch response {
            case .success(let response):
                print(response)
                repositoryDetail = response
            case .failure(let error):
                let errorDescription = error.errorDescription
                print(errorDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
