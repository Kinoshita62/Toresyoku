//
//  Action.swift
//  Toresyoku
//
//  Created by USER on 2024/09/11.
//

import Foundation
import SwiftUI

class Action {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func calculateCalories(protein: String, fat: String, carbohydrate: String) -> Double {
        let castingProtein = Double(protein) ?? 0
        let castingFat = Double(fat) ?? 0
        let castingCarbohydrate = Double(carbohydrate) ?? 0
        
        guard castingProtein >= 0, castingFat >= 0, castingCarbohydrate >= 0 else {
            return 0.0
        }
        
        return round((castingProtein * 4) + (castingFat * 9) + (castingCarbohydrate * 4))
    }

  func validateForm(name: String, protein: String, fat: String, carbohydrate: String, kcal: Double, nameValid: inout Bool, proteinValid: inout Bool, fatValid: inout Bool, carbohydrateValid: inout Bool, kcalValid: inout Bool) -> Bool {
        var isValid = true
        
        nameValid = !name.isEmpty
        if !nameValid { isValid = false }

        if let castingProtein = Double(protein), castingProtein >= 0, castingProtein <= 9999 {
            proteinValid = true
        } else {
            proteinValid = false
            isValid = false
        }

        if let castingFat = Double(fat), castingFat >= 0, castingFat <= 9999 {
            fatValid = true
        } else {
            fatValid = false
            isValid = false
        }

        if let castingCarbohydrate = Double(carbohydrate), castingCarbohydrate >= 0, castingCarbohydrate <= 9999 {
            carbohydrateValid = true
        } else {
            carbohydrateValid = false
            isValid = false
        }

        kcalValid = kcal >= 0
        if !kcalValid { isValid = false }

        return isValid
    }
}
