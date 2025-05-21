//
//  WireframeProtocol.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/21.
//

import UIKit

// 各画面ごとに wireframe を実装して画面遷移する
@MainActor
protocol WireframeProtocol {
    /// 遷移先画面を構築する
    func nextVC() -> UIViewController
    /// 画面遷移を担当
    func translation(navigationController: UINavigationController?, nextVC: UIViewController)
}
