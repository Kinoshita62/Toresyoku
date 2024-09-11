//
//  ConfirmButton.swift
//  Toresyoku
//
//  Created by USER on 2024/09/11.
//

import SwiftUI
import SwiftData

struct BasicButton: View {
    
    @Query private var imageColor: [ImageColorModel]
    var title: String
    var widthSize: CGFloat = 150
    var action: () -> Void
    
    var body: some View {
        Button(title) {
            action()
        }
        .font(.title3)
        .bold()
        .padding()
        .frame(width: widthSize, height: 35)
        .foregroundStyle(.black)
        .background(Color(
            red: imageColor.first?.imageColorRed ?? 0,
            green: imageColor.first?.imageColorGreen ?? 1,
            blue: imageColor.first?.imageColorBlue ?? 1,
            opacity: imageColor.first?.imageColorAlpha ?? 0.2
        ))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

#Preview {
    BasicButton(title: "タイトル", action: { print("決定") })
        .modelContainer(for: ImageColorModel.self)
}
