//
//  NoButton.swift
//  Toresyoku
//
//  Created by USER on 2024/09/11.
//

import SwiftUI

struct NoButton: View {
    var title: String = "戻る"
    var action: () -> Void
    
    var body: some View {
        Button(title) {
            action()
        }
        .font(.title3)
        .bold()
        .padding()
        .frame(width: 100, height: 35)
        .foregroundStyle(.black)
        .background(Color.gray .opacity(0.5))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

#Preview {
    NoButton(title: "戻る") {
        print("戻る")
    }
}
