//
//  RepositoryDetailResponse.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/07.
//

import Foundation

struct RepositoryDetailResponse: Decodable {
    var id: Int
    var name: String
    var owner: Owner
    var htmlUrl: String
    var description: String?
    var forksCount: Int
    var stargazersCount: Int
    var watchersCount: Int
    var updatedAt: String
    var language: String?

    struct Owner: Decodable {
        let id: Int
        let login: String
        let avatarUrl: String?
    }
}
