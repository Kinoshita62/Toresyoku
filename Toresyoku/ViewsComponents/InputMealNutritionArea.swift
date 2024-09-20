//
//  InputMealNutritionArea.swift
//  Toresyoku
//
//  Created by USER on 2024/09/19.
//

import SwiftUI

struct InputMealNutritionArea: View {
    
    var title: String
    @Binding var nutrition: String
    @Binding var valid: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
            TextField("", text: $nutrition)
                .font(.title3)
                .multilineTextAlignment(.trailing)
                .padding(4)
                .frame(width: 80)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .foregroundStyle(.black)
                .keyboardType(.decimalPad)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
            Text("g")
                .font(.title3)
            Spacer()
            if !valid {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.red)
            }
        }
        .padding(.horizontal)
    }
}

struct InputMealNutritionArea_Previews: PreviewProvider {
    @State static var nutrition = ""
    @State static var valid = false
    
    static var previews: some View {
        InputMealNutritionArea(title: "タイトル", nutrition: $nutrition, valid: $valid)
    }
}
