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
    func searchButtonTapped(searchWord: String) async throws
    func starButtonTapped(tappedCellIndex: Int) async
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
        case success(Repositories)
        case error(ErrorMessage)
    }

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    // MARK: - outputs

    @Published private(set) var state: State = .initial

    // MARK: - inputs

    @MainActor
    func searchButtonTapped(searchWord: String) async throws {
        state = .initial
        state = .loading
        let searchRepoRequest: SearchRepositoriesRequest = .init(searchWord: searchWord)
        do {
            let response: Result<SearchRepositoriesResponse, HTTPError> = try await apiClient.request(apiRequest: searchRepoRequest)
            switch response {
            case .success(let repositories):
                let repositories: Repositories = SearchRepositoryTranslator.translate(input: repositories)
                state = .success(repositories)
            case .failure(let error):
                let errorDescription = error.errorDescription
                let errorMessage: ErrorMessage = .init(title: "\(error.title)", description: errorDescription)
                state = .error(errorMessage)
            }
        } catch {
            state = .error(.init(title: HTTPError.unknownError.title, description: HTTPError.unknownError.errorDescription))
        }
    }

    @MainActor
    func starButtonTapped(tappedCellIndex: Int) async {
        switch state {
        case .success(var repositories):
            let addStarToRepositoryRequest: AddStarToRepositoryRequest = .init(owner: repositories.items[tappedCellIndex].owner.login, repo: repositories.items[tappedCellIndex].name)
            do {
                let response: Result<EmptyResponse, HTTPError> = try await apiClient.request(apiRequest: addStarToRepositoryRequest)
                switch response {
                case .success(_):
                    // TODO: スター解除機能を実装したら、リファクタリング検討する
                    if !repositories.items[tappedCellIndex].isStarred {
                        repositories.items[tappedCellIndex].stargazersCount += 1
                        repositories.items[tappedCellIndex].isStarred = true
                    }
                    state = .success(repositories)
                case .failure(let error):
                    let errorMessage: ErrorMessage = .init(title: "\(error.title)", description: error.errorDescription)
                    state = .error(errorMessage)
                }
            } catch {
                state = .error(.init(title: HTTPError.unknownError.title, description: HTTPError.unknownError.errorDescription))
            }
        case .initial, .loading, .error:
            print("")
        }
    }
}
