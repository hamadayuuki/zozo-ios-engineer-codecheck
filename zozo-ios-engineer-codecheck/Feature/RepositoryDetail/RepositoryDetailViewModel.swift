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

    private let apiClient: APIClientProtocol
    let request: RepositoryDetailRequest
    init(owner: String, repo: String, apiClient: APIClientProtocol) {
        self.apiClient = apiClient
        self.request = .init(owner: owner, repo: repo)
    }

    func viewDidLoad() async {
        do {
            let result: Result<RepositoryDetailResponse, HTTPError> = try await apiClient.request(apiRequest: request)
            switch result {
            case .success(let response):
                print(response)
                var newResponse = response
                newResponse.updatedAt = newResponse.updatedAt.formatDateString()   // TODO: Translator実装
                repositoryDetail = newResponse
            case .failure(let error):
                let errorDescription = error.errorDescription
                print(errorDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
