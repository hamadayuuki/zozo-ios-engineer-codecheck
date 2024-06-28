//
//  APIClientViewModel.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/25.
//

import Foundation

// アクセスレベルは他のファイルから呼び出せるように設定
protocol APIClientViewModelInput {
    func tappedGetButton()
}

protocol APIClientViewModelInputOutput {
    var isLoading: Bool { get }   // 外部からsetされない想定なのでgetterのみ
}

protocol APIClientViewModelProtocol: APIClientViewModelInput, APIClientViewModelInputOutput {}

final class APIClientViewModel: APIClientViewModelProtocol {

    // MARK: - outputs

    @Published private(set) var isLoading = false

    // MARK: - inputs

    func tappedGetButton() {
        isLoading = true
    }
}
