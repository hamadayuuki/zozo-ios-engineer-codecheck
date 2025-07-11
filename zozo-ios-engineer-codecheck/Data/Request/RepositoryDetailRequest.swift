//
//  RepositoryDetailRequest.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/07.
//

import Foundation

struct RepositoryDetailRequest: APIRequestProtocol {
    let owner: String
    let repo: String

    init(owner: String, repo: String) {
        self.owner = owner
        self.repo = repo
    }

    typealias Response = RepositoryDetailResponse

    // MARK: - APIRequestProtocol

    var baseURL: URL {
        guard let baseURL = URL(string: "https://api.github.com") else { fatalError("error baseURL") }
        return baseURL
    }

    var path: String {
        "/repos/\(self.owner)/\(self.repo)"
    }
    var method: HTTPMethod = .get
    var headers: [String: String] = [:]
    var body: Data?

    var urlQueryItem: URLQueryItem? = nil
}
