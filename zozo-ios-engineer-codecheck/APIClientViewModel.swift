//
//  APIClientViewModel.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/25.
//

import Foundation

private protocol APIClientViewModelInput {
    func tappedGetButton()
}

private protocol APIClientViewModelInputOutput {
    var isLoading: Bool { get }   // 外部からsetされない想定なのでgetterのみ
}

final class APIClientViewModel: APIClientViewModelInput, APIClientViewModelInputOutput {

    // MARK: - outputs

    @Published private(set) var isLoading = false

    // MARK: - inputs

    func tappedGetButton() {
        isLoading = true
    }
}
