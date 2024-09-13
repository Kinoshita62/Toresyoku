//
//  ProfileInputField.swift
//  Toresyoku
//
//  Created by USER on 2024/09/13.
//

import SwiftUI

struct ProfileInputField: View {
    var title: String
    @Binding var text: String
    
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
            Spacer()
            TextField("", text: $text)
                .font(.title3)
                .multilineTextAlignment(.trailing)
                .padding(4)
                .frame(width: 80)
                .background(.white, in: .rect(cornerRadius: 6))
                .foregroundStyle(.black)
                .keyboardType(.decimalPad)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}

struct ProfileInputField_Previews: PreviewProvider {
    @State static var text = "Text"
    static var previews: some View {
        ProfileInputField(title: "title", text: $text)
    }
}
