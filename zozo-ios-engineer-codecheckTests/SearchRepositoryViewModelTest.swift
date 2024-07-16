//
//  SearchRepositoryViewModelTest.swift
//  SearchRepositoryViewModelTest
//
//  Created by yuki.hamada on 2024/06/21.
//

import XCTest
@testable import zozo_ios_engineer_codecheck

///SearchRepositoryViewModel用のMockAPIClient
fileprivate class MockAPIClient: APIClientProtocol {
    /// MockAPIからのレスポンスを切り替える
    enum ResponseType {
        case success
        case failure
    }

    let responseType: ResponseType
    init(responseType: ResponseType) {
        self.responseType = responseType
    }

    func request<D: Decodable>(apiRequest: any APIRequestProtocol) async throws -> Result<D, HTTPError> {
        // APIClient が戻り値をジェネリクスを用いて設定しているため、
        // ジェネリクスをアンラップしないとSearchRepositoriesResponse等の"ジェネリクスではない型"を戻り値として使えない
        guard let stub = SearchRepositoriesResponse.stub() as? D else {
            return .failure(.responseError)
        }
        let successResponse: Result<D, HTTPError> = .success(stub)
        let failureResponse: Result<D, HTTPError> = .failure(.unknownError)

        switch responseType {
        case .success: return successResponse
        case .failure: return failureResponse
        }
    }
}

// MARK: - test

final class SearchRepositoryViewModelTest: XCTestCase {
    func test_リポジトリ1件の取得に成功() async throws {
        let successState: SearchRepositoryViewModel.State = .success(.stub())
        let mockAPIClient: MockAPIClient = .init(responseType: .success)
        let mockVM = SearchRepositoryViewModel(apiClient: mockAPIClient)
        XCTAssertEqual(mockVM.state, .initial)

        try await mockVM.tappedGetButton(searchWord: "")
        
        XCTAssertEqual(mockVM.state, successState)
    }

    func test_リポジトリ取得に失敗() async throws {
        let failureState: SearchRepositoryViewModel.State = .error(HTTPError.unknownError.errorDescription)
        let mockAPIClient: MockAPIClient = .init(responseType: .failure)
        let mockVM = SearchRepositoryViewModel(apiClient: mockAPIClient)
        XCTAssertEqual(mockVM.state, .initial)

        try await mockVM.tappedGetButton(searchWord: "")

        XCTAssertEqual(mockVM.state, failureState)
    }
}
