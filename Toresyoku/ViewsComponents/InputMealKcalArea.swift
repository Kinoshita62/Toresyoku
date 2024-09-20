//
//  InputMealKcalArea.swift
//  Toresyoku
//
//  Created by USER on 2024/09/19.
//

import SwiftUI

struct InputMealKcalArea: View {
    
    @Binding var kcal: Double
    @Binding var kcalValid: Bool
    
    var body: some View {
        HStack {
            Text("カロリー")
                .font(.title3)
            TextField("", value: $kcal, format: .number)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.trailing)
                .padding(4)
                .frame(width: 100)
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .foregroundStyle(.black)
                .keyboardType(.decimalPad)
                .disabled(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
            Text("kcal")
                .font(.title3)
            Spacer()
            if !kcalValid {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.red)
            }
        }
        .padding(.horizontal)
        .padding(.top, 15)
        .padding(.bottom, 30)
    }
}

struct InputMealKcalArea_Previews: PreviewProvider {
    @State static var kcal = 0.0
    @State static var kcalValid = false
    
    static var previews: some View {
        InputMealKcalArea(kcal: $kcal, kcalValid: $kcalValid)
    }
}
