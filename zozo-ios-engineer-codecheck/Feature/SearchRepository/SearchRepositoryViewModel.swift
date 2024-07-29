//
//  SearchRepositoryViewModel.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/25.
//

import Foundation

// MARK: - Protocol

// アクセスレベルは他のファイルから呼び出せるように設定
protocol SearchRepositoryViewModelInput {
    func viewDidLoad(searchWord: String) async throws
}

protocol SearchRepositoryViewModelOutput {
    var state: SearchRepositoryViewModel.State { get }
}

protocol SearchRepositoryViewModelProtocol: SearchRepositoryViewModelInput, SearchRepositoryViewModelOutput {}

// MARK: - ViewModel

final class SearchRepositoryViewModel: SearchRepositoryViewModelProtocol {
    enum State: Equatable {
        case initial   // init だと競合
        case loading
        case success(SearchRepositoriesResponse)
        case error(String)
    }

    private(set) var apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    // MARK: - outputs

    @Published private(set) var state: State = .initial

    // MARK: - inputs

    @MainActor
    func viewDidLoad(searchWord: String) async throws {
        state = .loading
        let searchRepoRequest: SearchRepositoriesRequest = .init(searchWord: searchWord)
        do {
            let response: Result<SearchRepositoriesResponse, HTTPError> = try await apiClient.request(apiRequest: searchRepoRequest)
            switch response {
            case .success(let repositories):
                state = .success(repositories)
            case .failure(let error):
                let errorDescription = error.errorDescription
                state = .error(errorDescription)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
