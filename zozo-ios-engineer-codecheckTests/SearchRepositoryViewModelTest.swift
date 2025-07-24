//
//  SearchRepositoryViewModelTest.swift
//  SearchRepositoryViewModelTest
//
//  Created by yuki.hamada on 2024/06/21.
//

import Testing
@testable import zozo_ios_engineer_codecheck

///SearchRepositoryViewModel用のMockAPIClient
final class MockAPIClient: APIClientProtocol {
    typealias Response = SearchRepositoriesResponse

    let mockResult: Result<Response, HTTPError>
    init(mockResult: Result<Response, HTTPError>) {
        self.mockResult = mockResult
    }

    func request<D: Decodable>(apiRequest: any APIRequestProtocol) async throws -> Result<D, HTTPError> {
        switch mockResult {
        case .success(let response):
            if D.self == Response.self {
                return .success(response as! D)
            } else {
                return .failure(.decodeError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - test

@MainActor
final class SearchRepositoryViewModelTest {

    /// 正常系
    ///
    /// 正常な入力データ & 期待通りの動作
    /// ViewModel が仕様通りに動作し、正しく状態を保持することを確認する
    ///
    /// 以下に示すような正常系の挙動をテストします
    ///  1. 検索欄に "swift" と入力
    ///  2. 検索ボタンをタップ
    ///  3. APIからレスポンスを受け取り、検索に成功する
    @Test
    func swiftを検索_リポジトリの検索に成功() async throws {
        let repositories: Repositories = SearchRepositoryTranslator.translate(input: .stub())
        let successResult: Result<SearchRepositoriesResponse, HTTPError> = .success(.stub())
        let mockAPIClient = MockAPIClient(mockResult: successResult)
        let viewModel = SearchRepositoryViewModel(apiClient: mockAPIClient)

        try await viewModel.searchButtonTapped(searchWord: "swift")

        #expect(viewModel.state == .success(repositories))
    }

    /// 準正常系
    ///
    /// 欠陥のある入力データ & 持続可能
    /// 部分的に不備があっても耐性を持っている実装か確認する
    ///
    /// 以下に示すような準正常系の挙動をテストします
    ///  1. 検索欄に "" と入力
    ///  2. 検索ボタンをタップ
    ///  3. （空文字を入力としているが）APIからレスポンスを受け取り、検索に成功する
    ///     - 本番環境で実行すると検索結果は空になるが、今回のテストではモックしているのでモックしたデータが返ってくる
    @Test
    func 空文字を検索_リポジトリの検索に成功() async throws {
        let repositories: Repositories = SearchRepositoryTranslator.translate(input: .stub())
        let successResult: Result<SearchRepositoriesResponse, HTTPError> = .success(.stub())
        let mockAPIClient = MockAPIClient(mockResult: successResult)
        let viewModel = SearchRepositoryViewModel(apiClient: mockAPIClient)

        try await viewModel.searchButtonTapped(searchWord: "")

        #expect(viewModel.state == .success(repositories))
    }

    /// 異常系
    ///
    /// 明確にエラーが出る条件 & エラー処理
    /// エラーが起こる場合でもクラッシュが起こらない設計になっているか確認する
    ///
    /// 以下に示すような異常系の挙動をテストします
    ///  1. 検索欄に "" と入力
    ///  2. 検索ボタンをタップ
    ///  3. APIに不具合があり、APIからレスポンスを受け取れない
    ///  4. ViewModel.state にエラーが発生したことを表現する エラーメッセージ が格納される
    @Test
    func APIClientに不具合があり_リポジトリの取得に失敗() async throws {
        let error: HTTPError = .decodeError
        let failureResult: Result<SearchRepositoriesResponse, HTTPError> = .failure(error)
        let mockAPIClient = MockAPIClient(mockResult: failureResult)
        let viewModel = SearchRepositoryViewModel(apiClient: mockAPIClient)

        try await viewModel.searchButtonTapped(searchWord: "")

        #expect(viewModel.state == .error(.init(title: error.title, description: error.errorDescription)))
    }
}
