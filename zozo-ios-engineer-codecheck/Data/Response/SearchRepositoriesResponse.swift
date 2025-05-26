//
//  SearchRepositoriesResponse.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/28.
//

import Foundation

struct SearchRepositoriesResponse: Decodable, Hashable {
    var items: [GithubRepository]
}

struct GithubRepository: Decodable, Hashable {
    var id: Int
    var name: String
    var fullName: String
    var owner: Owner
    var htmlUrl: String
    var description: String?
    var language: String?
    var stargazersCount: Int
    var watchersCount: Int
    var createdAt: String
    var updatedAt: String
    // GitHub API には存在しないので、自前で実装して変数を更新する必要ある
    var isStarred: Bool = false   // TODO: Translatorを実装し、追加する

    struct Owner: Decodable, Hashable {
        var id: Int
        var login: String   // owner name
    }
}

// MARK: - for test

extension SearchRepositoriesResponse {
    /// デバッグやテスト用
    ///
    /// length で受け取った長さ分のリストを返却
    static func stub(length: Int = 1) -> Self {
        .init(items: Array(repeating: (), count: length).enumerated().map { index, _ -> GithubRepository in
            GithubRepository(id: index, name: "hoge", fullName: "hoge/hoge", owner: .init(id: 0, login: "owner"), htmlUrl: "", description: "hoge hoge hoge", language: "swift", stargazersCount: 100, watchersCount: 100, createdAt: "", updatedAt: "")
        })
    }
}
