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
    let id: String
    var MealName: String
    var MealProtein: Double
    var MealFat: Double
    var MealCarbohydrate: Double
    var MealKcal: Double
//    var MealDate: Int
    
    init(MealName: String, MealProtein: Double, MealFat: Double, MealCarbohydrate: Double, MealKcal: Double /*MealDate: Int*/) {
        self.id = UUID().uuidString
        self.MealName = MealName
        self.MealProtein = MealProtein
        self.MealFat = MealFat
        self.MealCarbohydrate = MealCarbohydrate
        self.MealKcal = MealKcal
//        self.MealDate = MealDate
    }
}
