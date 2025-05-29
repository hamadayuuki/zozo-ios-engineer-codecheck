//
//  SearchRepositoryTranslator.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/27.
//

import Foundation

enum SearchRepositoryTranslator {
    static func translate(input: SearchRepositoriesResponse) -> Repositories {
        var repositories: Repositories = .init(items: [])
        for item in input.items {
            repositories.items.append(.init(id: item.id, fullName: item.fullName, name: item.name, description: item.description, language: item.language, stargazersCount: item.stargazersCount, owner: item.owner))
        }
        return repositories
    }
}
