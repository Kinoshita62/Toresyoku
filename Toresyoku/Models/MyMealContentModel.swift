//
//  MyMealContentModel.swift
//  Toresyoku
//
//  Created by USER on 2024/08/15.
//

import Foundation
import SwiftData

@Model
final class MyMealContentModel {
    var id: String
    var myMealName: String
    var myMealProtein: Double
    var myMealFat: Double
    var myMealCarbohydrate: Double
    var myMealKcal: Double
    
    init(myMealName: String, myMealProtein: Double, myMealFat: Double, myMealCarbohydrate: Double, myMealKcal: Double) {
        self.id = UUID().uuidString
        self.myMealName = myMealName
        self.myMealProtein = myMealProtein
        self.myMealFat = myMealFat
        self.myMealCarbohydrate = myMealCarbohydrate
        self.myMealKcal = myMealKcal
    }
}
