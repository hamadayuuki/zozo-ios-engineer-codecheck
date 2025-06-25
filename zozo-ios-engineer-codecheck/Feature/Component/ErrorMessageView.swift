//
//  ErrorMessageView.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2025/06/09.
//

import SwiftUI

struct ErrorMessageView: View {
    let errorMessage: ErrorMessage = .init(
        title: "エラーが発生しました",
        description: "エラーの原因はWi-Fiの不調？\nそれってあなたの感想ですよね"
    )

    var body: some View {
        VStack(spacing: 12) {
            Text("\(errorMessage.title)")
                .font(.system(size: 16, weight: .bold))

            Text("\(errorMessage.description)")
                .font(.system(size: 12, weight: .regular))

            Button(action: {
                print("tapped error ok button")
            }, label: {
                Text("OK")
                    .font(.system(size: 12, weight: .regular))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 36)
                    .background(.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            })
            .padding(.top, 24)
        }
        .padding(.vertical, 48)
        .padding(.horizontal, 48)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    ErrorMessageView()
}
