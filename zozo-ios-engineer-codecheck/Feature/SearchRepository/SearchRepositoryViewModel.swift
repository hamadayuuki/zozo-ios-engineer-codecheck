//
//  SearchRepositoryViewModel.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/25.
//

import Foundation

// MARK: - Protocol

// アクセスレベルは他のファイルから呼び出せるように設定
@MainActor
protocol SearchRepositoryViewModelInput {
    func searchButtonTapped(searchWord: String) async throws
    func starButtonTapped(tappedCellIndex: Int) async
}

@MainActor
protocol SearchRepositoryViewModelOutput {
    var state: SearchRepositoryViewModel.State { get }
}

@MainActor
protocol SearchRepositoryViewModelProtocol: SearchRepositoryViewModelInput, SearchRepositoryViewModelOutput {}

// MARK: - ViewModel

@MainActor
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

    func searchButtonTapped(searchWord: String) async throws {
        state = .initial
        state = .loading
        let searchRepoRequest: SearchRepositoriesRequest = .init(searchWord: searchWord)
        do {
            let response: Result<SearchRepositoriesResponse, HTTPError> = try await apiClient.request(apiRequest: searchRepoRequest)
            switch response {
            case .success(let repositories):
                var repositories: Repositories = SearchRepositoryTranslator.translate(input: repositories)
                try await withThrowingTaskGroup(of: (Int, Bool).self) { group in
                    for (index, repo) in repositories.items.enumerated() {
                        group.addTask {
                            let starredRepositoryRequest: StarredRepositoryRequest = .init(owner: repo.owner.login, repo: repo.name)
                            let isStarredRepository: Result<EmptyResponse, HTTPError> = try await self.apiClient.request(apiRequest: starredRepositoryRequest)
                            switch isStarredRepository {
                            case .success:
                                return (index, true)
                            case .failure:
                                return (index, false)
                            }
                        }
                    }
                    for try await (index, starred) in group {
                        repositories.items[index].isStarred = starred
                    }
                }

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

    func starButtonTapped(tappedCellIndex: Int) async {
        switch state {
        case .success(var repositories):
            if !repositories.items[tappedCellIndex].isStarred {
                // リポジトリにスターを付与
                let addStarToRepositoryRequest: AddStarToRepositoryRequest = .init(owner: repositories.items[tappedCellIndex].owner.login, repo: repositories.items[tappedCellIndex].name)
                do {
                    let response: Result<EmptyResponse, HTTPError> = try await apiClient.request(apiRequest: addStarToRepositoryRequest)
                    switch response {
                    case .success(_):
                        repositories.items[tappedCellIndex].stargazersCount += 1
                        repositories.items[tappedCellIndex].isStarred = true
                        state = .success(repositories)
                    case .failure(let error):
                        let errorMessage: ErrorMessage = .init(title: "\(error.title)", description: error.errorDescription)
                        state = .error(errorMessage)
                    }
                } catch {
                    state = .error(.init(title: HTTPError.unknownError.title, description: HTTPError.unknownError.errorDescription))
                }
            } else {
                // リポジトリからスターを削除
                let removeStarFromRepositoryRequest: RemoveStarFromRepositoryRequest = .init(owner: repositories.items[tappedCellIndex].owner.login, repo: repositories.items[tappedCellIndex].name)
                do {
                    let response: Result<EmptyResponse, HTTPError> = try await apiClient.request(apiRequest: removeStarFromRepositoryRequest)
                    switch response {
                    case .success(_):
                        repositories.items[tappedCellIndex].stargazersCount -= 1
                        repositories.items[tappedCellIndex].isStarred = false
                        state = .success(repositories)
                    case .failure(let error):
                        let errorMessage: ErrorMessage = .init(title: "\(error.title)", description: error.errorDescription)
                        state = .error(errorMessage)
                    }
                } catch {
                    state = .error(.init(title: HTTPError.unknownError.title, description: HTTPError.unknownError.errorDescription))
                }
            }
        case .initial, .loading, .error:
            print("")
        }
    }
}
