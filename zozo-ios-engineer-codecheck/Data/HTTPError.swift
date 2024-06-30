//
//  HTTPError.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/28.
//

import Foundation

enum HTTPError: Error {
    /// レスポンスを受け取れなかった
    case responseError

    /// レスポンスを正しくデコードできなかった
    case decodeError

    // 4xx クライアントエラー
    case badRequest  // 400 Bad Request
    case unauthorized  // 401 Unauthorized
    case forbidden  // 403 Forbidden
    case notFound  // 404 Not Found
    case methodNotAllowed  // 405 Method Not Allowed
    case requestTimeout  // 408 Request Timeout
    case conflict  // 409 Conflict
    case tooManyRequests  // 429 Too Many Requests
    case clientError(Int)  // その他の4xxエラー

    // 5xx サーバーエラー
    case internalServerError  // 500 Internal Server Error
    case notImplemented  // 501 Not Implemented
    case badGateway  // 502 Bad Gateway
    case serviceUnavailable  // 503 Service Unavailable
    case gatewayTimeout  // 504 Gateway Timeout
    case serverError(Int)  // その他の5xxエラー

    case unknownError  // 未知のエラー

    var errorDescription: String {
        switch self {
        case .responseError:
            return "レスポンスを受信できませんでした"
        case .decodeError:
            return "データのデコード中にエラーが発生しました"
        // 4xx クライアントエラー
        case .badRequest:
            return "リクエストが無効です (400)"
        case .unauthorized:
            return "認証に失敗しました (401)"
        case .forbidden:
            return "アクセスが拒否されました (403)"
        case .notFound:
            return "リソースが見つかりません (404)"
        case .methodNotAllowed:
            return "許可されていないメソッドです (405)"
        case .requestTimeout:
            return "リクエストがタイムアウトしました (408)"
        case .conflict:
            return "リクエストが競合しています (409)"
        case .tooManyRequests:
            return "リクエスト回数の上限を超えました (429)"
        case .clientError(let code):
            return "クライアントエラーが発生しました (\(code))"
        // 5xx サーバーエラー
        case .internalServerError:
            return "サーバー内部でエラーが発生しました (500)"
        case .notImplemented:
            return "機能が実装されていません (501)"
        case .badGateway:
            return "不正なゲートウェイです (502)"
        case .serviceUnavailable:
            return "サービスが利用できません (503)"
        case .gatewayTimeout:
            return "ゲートウェイがタイムアウトしました (504)"
        case .serverError(let code):
            return "サーバーエラーが発生しました (\(code))"
        case .unknownError:
            return "未知のエラーが発生しました"
        }
    }
}
