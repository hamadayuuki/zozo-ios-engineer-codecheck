//
//  SearchRepositoriesRequest.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/28.
//

import Foundation

/// APIRequest に則ってRequestを作成
///
/// ```
/// let request = GIthubAPI.SearchRepository(searchWord: "swift")
/// ```
struct SearchRepositoriesRequest: APIRequestProtocol {
    let searchWord: String

    init(searchWord: String) {
        self.searchWord = searchWord
    }

    typealias Response = SearchRepositoriesResponse

    // MARK: - APIRequestProtocol

    var baseURL: URL {
        guard let baseURL = URL(string: "https://api.github.com") else { fatalError("error baseURL") }
        return baseURL
    }

    var path: String {
        "/search/repositories"
    }

    var method: HTTPMethod {
        .get
    }

    var body: Data? {
        nil
    }

    var urlQueryItem: URLQueryItem {
        URLQueryItem(name: "q", value: searchWord)
    }
}
