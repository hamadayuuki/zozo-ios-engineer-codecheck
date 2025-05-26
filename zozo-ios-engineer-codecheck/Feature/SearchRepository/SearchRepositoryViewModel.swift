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
    func tappedStarButton(tappedCellIndex: Int) async
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
                state = .success(repositories)
            case .failure(let error):
                let errorDescription = error.errorDescription
                state = .error(errorDescription)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    @MainActor
    func tappedStarButton(tappedCellIndex: Int) async {
        switch state {
        case .success(var repositories):
            let addStarToRepositoryRequest: AddStarToRepositoryRequest = .init(owner: repositories.items[tappedCellIndex].owner.login, repo: repositories.items[tappedCellIndex].name)
            do {
                let response: Result<EmptyResponse, HTTPError> = try await apiClient.request(apiRequest: addStarToRepositoryRequest)
                switch response {
                case .success(_):
                    repositories.items[tappedCellIndex].isStarred.toggle()
                case .failure(let error):
                    print(error.errorDescription)   // TODO: エラーを画面に表示
                }
            } catch {

            }
        case .initial, .loading, .error:
            print("")
        }
    }
}
