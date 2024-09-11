//
//  MealContentModel.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import Foundation
import SwiftData

@Model
final class MealContentModel {
    var id: String
    var mealName: String
    var mealProtein: Double
    var mealFat: Double
    var mealCarbohydrate: Double
    var mealKcal: Double
    var mealDate: Date
    
    init(mealName: String, mealProtein: Double, mealFat: Double, mealCarbohydrate: Double, mealKcal: Double, mealDate: Date) {
        self.id = UUID().uuidString
        self.mealName = mealName
        self.mealProtein = mealProtein
        self.mealFat = mealFat
        self.mealCarbohydrate = mealCarbohydrate
        self.mealKcal = mealKcal
        self.mealDate = mealDate
    }
}
