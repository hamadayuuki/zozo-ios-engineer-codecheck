//
//  SearchRepositoriesResponse.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/28.
//

struct SearchRepositoriesResponse: Decodable {
    var items: [GithubRepository]

    init(items: [GithubRepository]) {
        self.items = items
    }
}

struct GithubRepository: Decodable {
    var id: Int
    var name: String
    var fullName: String
    var htmlUrl: String
    var description: String
    var language: String?
    var stargazersCount: Int
    var watchersCount: Int
    var createdAt: String
    var updatedAt: String

    init(id: Int, name: String, fullName: String, htmlUrl: String, description: String, language: String? = nil, stargazersCount: Int, watchersCount: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.htmlUrl = htmlUrl
        self.description = description
        self.language = language
        self.stargazersCount = stargazersCount
        self.watchersCount = watchersCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - for test

extension SearchRepositoriesResponse {
    /// テスト用
    static func mock() -> [GithubRepository] {
        return [
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

