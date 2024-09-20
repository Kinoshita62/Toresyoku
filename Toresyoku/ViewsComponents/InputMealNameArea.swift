//
//  InputMealNameArea.swift
//  Toresyoku
//
//  Created by USER on 2024/09/19.
//

import SwiftUI

struct InputMealNameArea: View {
    
    @Binding var name: String
    @Binding var nameValid: Bool
    
    var body: some View {
        HStack {
            Text("メニュー")
                .font(.title3)
            TextField("", text: $name)
                .foregroundStyle(.black)
                .padding(4)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .font(.title3)
                .frame(width: 220)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
            Spacer()
            if !nameValid {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.red)
            }
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

struct InputMealNameArea_Previews: PreviewProvider {
    @State static var name = ""
    @State static var nameValid = false
    
    static var previews: some View {
        InputMealNameArea(name: $name, nameValid: $nameValid)
    }
}
