//
//  String+extension.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/05/16.
//

import Foundation

extension String {
    /// yyyy-MM-dd'T'HH:mm:ssZ -> yyyy-MM-dd HH:mm
    func formatDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Z 形式を解析するために重要

        if let date = dateFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            outputFormatter.locale = Locale(identifier: "ja_JP") // 出力形式に合わせてローケルを設定 (日本)
            outputFormatter.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60)! // JST

            return outputFormatter.string(from: date)
        } else {
            // 解析に失敗した場合は、何らかのデフォルト値を返すか、
            // より適切なエラーハンドリングを行う必要があります。
            // ここでは、元の文字列をそのまま返す例を示します。
            print("警告: 日付文字列 '\(self)' の解析に失敗しました。")
            return self
        }
    }
}
