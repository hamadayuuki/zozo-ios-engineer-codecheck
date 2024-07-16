//
//  SearchRepositoriesResponse.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/28.
//

struct SearchRepositoriesResponse: Decodable, Hashable {
    var items: [GithubRepository]
}

struct GithubRepository: Decodable, Hashable {
    var id: Int
    var name: String
    var fullName: String
    var htmlUrl: String
    var description: String
    var language: String
    var stargazersCount: Int
    var watchersCount: Int
    var createdAt: String
    var updatedAt: String
}

// MARK: - for test

extension SearchRepositoriesResponse {
    /// テスト用
    static func mock() -> [GithubRepository] {
        [
            .init(
                id: 0,
                name: "",
                fullName: "",
                htmlUrl: "",
                description: "",
                language: "",
                stargazersCount: 0,
                watchersCount: 0,
                createdAt: "",
                updatedAt: ""
            )
        ]
    }
}
