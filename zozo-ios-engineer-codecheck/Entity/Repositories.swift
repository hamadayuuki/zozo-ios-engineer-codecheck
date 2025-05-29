//
//  Repositories.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/27.
//

import Foundation

struct Repositories: Equatable, Hashable {
    var items: [Repository]
}

struct Repository: Equatable, Hashable {
    var id: Int
    var fullName: String
    var name: String
    var description: String?
    var language: String?
    var stargazersCount: Int
    var owner: GithubRepository.Owner
    var isStarred: Bool = false
}
