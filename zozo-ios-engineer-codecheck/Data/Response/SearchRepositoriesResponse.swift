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
    ///
    /// length で受け取った長さ分のリストを返却
    static func stub(length: Int = 1) -> Self {
        var response: Self = .init(items: [])
        for id in 0..<length {
            // id は重複しないように
            let item: GithubRepository = .init(id: id, name: "hoge", fullName: "hoge/hoge", htmlUrl: "", description: "hoge hoge hoge", language: "swift", stargazersCount: 100, watchersCount: 100, createdAt: "", updatedAt: "")
            response.items.append(item)
        }
        return response
    }
}
