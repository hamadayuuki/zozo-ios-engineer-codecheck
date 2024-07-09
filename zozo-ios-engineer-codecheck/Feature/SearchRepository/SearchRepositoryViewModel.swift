//
//  SearchRepositoryViewModel.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/25.
//

import Foundation

// アクセスレベルは他のファイルから呼び出せるように設定
protocol SearchRepositoryViewModelInput {
    func tappedGetButton(searchWord: String) async throws
}

protocol SearchRepositoryViewModelInputOutput {
    var isLoading: Bool { get }   // 外部からsetされない想定なのでgetterのみ
    var isError: Bool { get }
    var repositories: SearchRepositoriesResponse { get }
}

protocol SearchRepositoryViewModelProtocol: SearchRepositoryViewModelInput, SearchRepositoryViewModelInputOutput {}

final class SearchRepositoryViewModel: SearchRepositoryViewModelProtocol {
    private let apiClient: APIClient = .init()

    // MARK: - outputs

    // TODO: - 状態をenumで一元管理する
    @Published private(set) var isLoading = false
    @Published private(set) var isError = false
    @Published private(set) var repositories: SearchRepositoriesResponse = .init(items: [])

    // MARK: - inputs

    @MainActor
    func tappedGetButton(searchWord: String) async throws {
        isLoading = true
        let searchRepoRequest: SearchRepositoriesRequest = .init(searchWord: searchWord)
        do {
            let response: Result<SearchRepositoriesResponse, HTTPError> = try await apiClient.request(apiRequest: searchRepoRequest)
            switch response {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                isError = true
            }
        } catch {
            isError = true
        }
        isLoading = false
    }
}
