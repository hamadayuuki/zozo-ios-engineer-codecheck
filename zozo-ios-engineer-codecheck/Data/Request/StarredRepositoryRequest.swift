//
//  StarredRepositoryRequest.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/06/30.
//

import Foundation

struct StarredRepositoryRequest: APIRequestProtocol {
    let owner: String
    let repo: String

    init(owner: String, repo: String) {
        self.owner = owner
        self.repo = repo
    }

    typealias Response = EmptyResponse

    var baseURL: URL {
        guard let baseURL = URL(string: "https://api.github.com") else { fatalError("error baseURL") }
        return baseURL
    }

    var path: String {
        "/user/starred/\(self.owner)/\(self.repo)"
    }

    var method: HTTPMethod = .get
    var headers: [String: String] = [
        "Accept": "application/vnd.github+json",
        "Authorization": "Bearer \(GitHubAPIConfig.accessToken)",
        "X-GitHub-Api-Version": "2022-11-28"
    ]
    var urlQueryItem: URLQueryItem? = nil

    var body: Data?
}
